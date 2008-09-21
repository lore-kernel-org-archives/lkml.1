Return-Path: <linux-kernel-owner+w=401wt.eu-S1751920AbYIUQF7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751920AbYIUQF7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2008 12:05:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751765AbYIUQFv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Sep 2008 12:05:51 -0400
Received: from lvps87-230-0-242.dedicated.hosteurope.de ([87.230.0.242]:52319
	"EHLO lvps87-230-0-242.dedicated.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751637AbYIUQFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2008 12:05:51 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Sun, 21 Sep 2008 12:05:50 EDT
Message-Id: <50F88745-08CD-4BAD-965E-619A8DDE7085@it-loops.com>
From: Guntsche Michael <mike@it-loops.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v929.2)
Subject: 2.6.26: Parport printing problem
Date: Sun, 21 Sep 2008 17:59:08 +0200
X-Mailer: Apple Mail (2.929.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi list,

I am having some problems with printing to an epson printer connected  
to the parallel port.
I have an old computer that acts as my firewall/print server. Every  
now and then I print out some pages on this setup.
At the beginning of the year I printed a pdf file without any  
problems. This weekend I wanted to print out a small PDF but instead  
of getting the page, I just got gibberish showing up on the page. I  
did not change anything in my cups setup so I booted to 2.6.25 and  
tried again, same problem.
Since this is an Epson inkjet printer I turned off cups and fired up  
the escpuil tool.

	escputil -i -r /dev/lp0

This should normally print out the inklevels. But instead if the ouput  
I just got gibberish printed out again. For me it looked like that the  
data, got somehow mangled on the way to the printer. I recompiled the  
kernel and tried it once again with parport_pc in polling mode. Same  
result.

I then connected the printer via its USB port to another computer  
running 2.6.26 and tried escputil again. It worked without any  
problems. I saw the ink levels and could also trigger the print head  
cleaning sequence. A test print out from cups and the PDF printout  
worked as well. I then connected the printer to this new server with  
the parallel port. I got the same result as with the other computer.  
Instead of ink levels or a printout I just got gibberish on the page.

Since then I moved my cups setup to the server since it is faster  
anyway. Nevertheless I still do not understand why printing does not  
work via the parallel port.
On the new machine parport_pc even detects the type and name of the  
printer, so the connection is definitely working. It just looks like  
that output sent via the parport somehow gets tampered with.
Maybe someone has an idea.

Please CC me since I am not subscribed to the list.

Kind regards,
Michael
