Return-Path: <linux-kernel-owner+w=401wt.eu-S1753606AbYFSUZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753606AbYFSUZ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 16:25:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751238AbYFSUZT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 16:25:19 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:60548 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000AbYFSUZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 16:25:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=nwOP0GY4VQz0htQ9dRfv3X39ESRVHtQz4NSYwd883ks0BQ3r23G5y4R43lsuchhZ6Q
         d169eeZhuVNaUNWrY0n1aNqnukpx2ieRmRXrdFc8W3iDre4FBQmKf99uWl1CZRPXezfF
         /wVPRemm5j+Kabq6whjvETnhKZ3+R9Ue8ve/Y=
Message-ID: <19f34abd0806191325s4c10660dt8da146ad2ef4e63b@mail.gmail.com>
Date: Thu, 19 Jun 2008 22:25:17 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Robert Hancock" <hancockr@shaw.ca>
Subject: Re: Strange problem with e1000 driver - ping packet loss
Cc: vatsa@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       e1000-devel@lists.sourceforge.net, varunc@linux.vnet.ibm.com,
       jbarnes@virtuousgeek.org, greg@kroah.com, "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <485A9678.5000707@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fa.QBOn2aWyqGnBJJticG4h09lpxD0@ifi.uio.no>
	 <485A9678.5000707@shaw.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/19/08, Robert Hancock <hancockr@shaw.ca> wrote:
> Srivatsa Vaddagiri wrote:
>
> > Hi,
> >        I happened to look at a system which was exhibiting poor ping
> > performance with e1000 driver (in 2.6.25) and had some questions regarding
> that.
> >
> > Ping test was done between the system and a laptop, which were connected
> > using a straight ethernet cable. Ping reported round trip times running
> > into seconds (!) and also packet loss.
> >
> > Upon some investigation, I found that the interrupt count field in
> > /proc/interrupts (associated with eth1) is not incrementing as fast as
> > it should. Moreover eth1 interrupt line is shared with the hard disk
> > interrupt (ata_piix) as below:

Just FYI, it seems that more people have the same (?) problem:

http://www.ussg.iu.edu/hypermail/linux/kernel/0806.2/0499.html

It might be worth joining forces to fight down the bug once and for
all if it's still not fixed after one and a half years? Sorry, I
really meant error instead of bug.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
