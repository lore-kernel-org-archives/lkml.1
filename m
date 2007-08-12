Return-Path: <linux-kernel-owner+w=401wt.eu-S937390AbXHLTkh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937390AbXHLTkh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 15:40:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937825AbXHLTkP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 15:40:15 -0400
Received: from smtp101.rog.mail.re2.yahoo.com ([206.190.36.79]:40148 "HELO
	smtp101.rog.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S936374AbXHLTjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 15:39:46 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=rogers.com;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=EJSXgaFZFDsWkGXR90XEwzviGMkAucUNfNaRzXFLrkEBNJ+HKAzD1/LrUCJ6d308sQk+BiUtS3tYzEmE0KAfrWfLusMAp3H+5U5EJdCaO7W4+o0Nytw+L3qKVa0DNA/RjXzTZPybo3t+P7KRcHzYRY+7YEjL1FYIezMwGs9y+BI=  ;
X-YMail-OSG: wxzj.OgVM1kK0NYJfb9_dDvODPhleilOFDTKndfbNEMs_Mhhn1K0goIQYgpML9xdPQ--
From: Mark Cannon <random.bits@rogers.com>
To: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: Use of directories to hold root?
Date: Sun, 12 Aug 2007 15:39:48 -0400
User-Agent: KMail/1.9.6
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
References: <200708101724.26724.random.bits@rogers.com> <46BCFE01.2040703@zytor.com> <Pine.LNX.4.64.0708111753510.3101@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0708111753510.3101@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708121539.48332.random.bits@rogers.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 11 August 2007, Jan Engelhardt wrote:
> 
> On Aug 10 2007 17:08, H. Peter Anvin wrote:
> >Jan Engelhardt wrote:
> >> On Aug 10 2007 17:24, Mark Cannon wrote:
> >>> You pass the kernel the root option to specify the root partition.
> >>> Is there a way to identify a directory in that partition that holds the
> >>> root or something equivalent to this?
> >> 
> >> No, but you can use pivot_root.
> >
> >Or better yet, use an initramfs with MS_MOVE; same as you would with the
> >"normal" use of initramfs.
> 
> mount --move /foo /
> => error
> 
> What did I miss?
> 
> 
> 
> 	Jan
Thank you for the prompt replies. I have looked int pivot_root and
with my limited knowledge it looks like I could do this in the linuxrc 
during start up. I believe the new kernel 2.6.21 is independent of the
root tree, so right after it mounts the old root /dev/sda3, it then can
pivot-root to /ker2621. 
This can quickly be tested in the lab. I already use chroot for tests. Was
unaware of pivot_root.

I am not sure I understand initramfs with MS_MOVE concept. I will look into
it. Any pointers for documentation? 

Again, thank you for the help.

Mark Cannon


