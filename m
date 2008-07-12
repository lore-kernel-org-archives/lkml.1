Return-Path: <linux-kernel-owner+w=401wt.eu-S1755342AbYGLUui@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755342AbYGLUui (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 16:50:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752768AbYGLUub
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 16:50:31 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44654
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752313AbYGLUub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 16:50:31 -0400
Date: Sat, 12 Jul 2008 13:50:31 -0700 (PDT)
Message-Id: <20080712.135031.193694627.davem@davemloft.net>
To: olsajiri@gmail.com
Cc: tgraf@suug.ch, johannes@sipsolutions.net, linux-kernel@vger.kernel.org
Subject: Re: genetlink: genl_unregister_mc_group
From: David Miller <davem@davemloft.net>
In-Reply-To: <4878D9D3.1020109@gmail.com>
References: <4878D9D3.1020109@gmail.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <olsajiri@gmail.com>
Date: Sat, 12 Jul 2008 18:20:35 +0200

> is there a special reason why genl_unregister_mc_group 
> is not exported for module usage?

When there is an in-tree modular use of this function, we
will export it.
