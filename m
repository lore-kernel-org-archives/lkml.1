Return-Path: <linux-kernel-owner+w=401wt.eu-S932469AbXDAGR1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932469AbXDAGR1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 02:17:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932566AbXDAGR1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 02:17:27 -0400
Received: from 1wt.eu ([62.212.114.60]:1601 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932469AbXDAGR0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 02:17:26 -0400
Date: Sun, 1 Apr 2007 08:17:07 +0200
From: Willy Tarreau <w@1wt.eu>
To: Pedram M <pmessri@gmail.com>
Cc: kernel-janitors@lists.osdl.org, linux-kernel@vger.kernel.org
Subject: Re: my first janitorial
Message-ID: <20070401061707.GB943@1wt.eu>
References: <9c9aa5d00703310639q68fa5d19k4d8e3bfb56b1fa6@mail.gmail.com> <9c9aa5d00703312224t1948b24bhe34199f19cbda4fb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9c9aa5d00703312224t1948b24bhe34199f19cbda4fb@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, Mar 31, 2007 at 10:24:12PM -0700, Pedram M wrote:
> How about this one? Am I doing it right now?
> If not, please try to explain more to me what I am
> doing wrong.

You have made several mistakes :
  - you must select an appropriate subject for your mail. Nobody cares
    that it is your first mail, what they care about is the problem you
    are trying to fix and what it applies to. Preferably start your
    subject with [PATCH] so that people can quickly notice it without
    having to open it first.

  - you did not send a description of your patch. It is important to
    have a full description, it can be from 1 line to 1 page depending
    on the complexity of the issue. It is important to explain why you
    think you are right so that people can argue if they don't agree.
    Please also try to be as factual as possible, because your message
    will become the commit message. It means that sentences such as
    "I think that ..." are not the best we can write.

  - you must sign your patch. For this, add a "Signed-Off-By:" footer.
    Take a look at other patches for this.

   - your patch was cut and cannot apply to anything. A proper patch starts
     with line beginning with "---" line, followed by a line with "+++",
     both indicating the file your patch is supposed to apply to. Make your
     patch with one level directory for the kernel so that it can apply with
     "patch -p1". For instance:

        $ diff -u linux-2.6.20/Makefile linux-2.6.20-mine/Makefile

     Another solution is to use '.' as the directory, in order to add one
     directory level for "patch -p1" to be happy :

        $ diff -u ./Makefile.orig ./Makefile

Hoping this helps,
Willy


> @@ -4760,7 +4760,7 @@
> 	for (i = 0; i < NR_CARDS; i++) {
> 		/* look for a Cyclades card by vendor and device id */
> 		while ((device_id = cy_pci_dev_id[dev_index]) != 0) {
> -			if ((pdev = pci_find_device(PCI_VENDOR_ID_CYCLADES,
> +			if ((pdev = pci_get_device(PCI_VENDOR_ID_CYCLADES,
> 						   device_id, pdev)) == 
> 						   NULL) {
> 				dev_index++;	/* try next device id */
> 			} else {
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
