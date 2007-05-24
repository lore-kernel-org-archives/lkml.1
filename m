Return-Path: <linux-kernel-owner+w=401wt.eu-S1763597AbXEXDlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763597AbXEXDlU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 23:41:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760752AbXEXDlL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 23:41:11 -0400
Received: from outbound-mail-78.bluehost.com ([69.89.22.27]:41189 "HELO
	outbound-mail-78.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760555AbXEXDlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 23:41:10 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC PATCH] PCI MMCONFIG: add validation against ACPI motherboard resources
Date: Wed, 23 May 2007 20:40:53 -0700
User-Agent: KMail/1.9.6
Cc: Olivier Galibert <galibert@pobox.com>, Robert Hancock <hancockr@shaw.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Chuck Ebbert <cebbert@redhat.com>, Len Brown <lenb@kernel.org>
References: <4635510D.4060103@shaw.ca> <alpine.LFD.0.98.0705232016350.3890@woody.linux-foundation.org> <alpine.LFD.0.98.0705232018380.3890@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0705232018380.3890@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705232040.53651.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 76.102.120.196 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, May 23, 2007 8:20:14 Linus Torvalds wrote:
> On Wed, 23 May 2007, Linus Torvalds wrote:
> > Sure. I think mmconfig is perfectly sane if it falls back to conf1
> > accesses for legacy stuff..
>
> .. but without a regression, it's obviously a post-2.6.22 thing, I guess I
> should make that clear, just because I think people send me patches after
> -rc1 way too eagerly just because they think it fixes a bug.
>
> Basically if it's not somethign that has _ever_ worked some way, it's not
> a bug, it's a feature ;)

No, I know better than to send something after your merge window closes.  I 
have no desire to be flamed even further on this topic.  :)

And come to think of it, adding the enable/disable bits might be good even 
with the patch to make legacy accesses go through type 1, since PCIe BAR 
probing is probably done the same way (I haven't looked) and so we might run 
into the same problems there.

Thanks,
Jesse

