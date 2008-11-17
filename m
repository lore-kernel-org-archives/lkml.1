Return-Path: <linux-kernel-owner+w=401wt.eu-S1755804AbYKQBD4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755804AbYKQBD4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 20:03:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753646AbYKQBDr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 20:03:47 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36447 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752604AbYKQBDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 20:03:47 -0500
Message-ID: <4920C21C.2030605@zytor.com>
Date: Sun, 16 Nov 2008 17:00:12 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu,
       tglx@linutronix.de, linux-kernel@vger.kernel.org, travis@sgi.com
Subject: Re: [PATCH] sparse_irq aka dyn_irq v13
References: <491434FB.2050904@kernel.org> <20081107124957.GA21709@elte.hu>	 <49168BD3.5010204@kernel.org> <20081109073813.GA17180@elte.hu>	 <86802c440811090003g5ac53822y852a4c1096228f8b@mail.gmail.com>	 <20081110094033.GL22392@elte.hu>	 <20081110015511.453a801e.akpm@linux-foundation.org>	 <4918065A.6050402@kernel.org> <20081110100329.GA19970@elte.hu>	 <491A9F87.8040403@kernel.org> <20081112120814.GG11352@elte.hu>	 <491C8B38.9060901@kernel.org>	 <20081113131850.d94fb229.akpm@linux-foundation.org> <1226869137.7178.175.camel@pasglop> <4920B069.5020203@kernel.org> <4920B15E.6090200@zytor.com> <4920B2A4.4040900@kernel.org> <4920B3E3.4050707@zytor.com> <4920B911.7060504@kernel.org> <4920BA3A.5090100@zytor.com> <4920BCA8.6080600@kernel.org> <4920BF62.10700@zytor.com> <4920C19E.8090402@kernel.org>
In-Reply-To: <4920C19E.8090402@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> 
> so we have one list to map domain/bus/dev/func to bits [31,12] in irq ?
> 

That works, although having a more generic allocation mechanism which
isn't so tied to MSI-X would make more sense.

	-hpa
