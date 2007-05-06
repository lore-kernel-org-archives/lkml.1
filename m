Return-Path: <linux-kernel-owner+w=401wt.eu-S933464AbXEFB6w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933464AbXEFB6w (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 21:58:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934358AbXEFB6w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 21:58:52 -0400
Received: from mail-in-05.arcor-online.net ([151.189.21.45]:39621 "EHLO
	mail-in-05.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933464AbXEFB6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 21:58:51 -0400
In-Reply-To: <20070506004737.31233.52611.stgit@localhost.localdomain>
References: <20070506004737.31233.52611.stgit@localhost.localdomain>
Mime-Version: 1.0 (Apple Message framework v623)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <67c6bf6b7d37f5e133398ea83edeac78@kernel.crashing.org>
Content-Transfer-Encoding: 7bit
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       linux-pcmcia@lists.infradead.org
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: [PATCH] [POWERPC] 8xx: mpc885ads pcmcia support
Date: Sun, 6 May 2007 03:04:14 +0200
To: Vitaly Bordug <vitb@kernel.crashing.org>
X-Mailer: Apple Mail (2.623)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> +		pcmcia@0080 {

> +			#interrupt-cells = <1>;

> +			interrupt-parent = <ff000000>;
> +			interrupts = <d 1>;
> +		};

Since this node's children's interrupt representation
is different from the node's parent's, you need an
interrupt-map in here.  You also forgot "#address-cells"
and I think you need "ranges" too?


Segher

