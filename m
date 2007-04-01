Return-Path: <linux-kernel-owner+w=401wt.eu-S933903AbXDATAG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933903AbXDATAG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 15:00:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933856AbXDATAF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 15:00:05 -0400
Received: from SMTP.andrew.cmu.edu ([128.2.10.212]:34513 "EHLO
	smtp.andrew.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933903AbXDATAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 15:00:01 -0400
X-Greylist: delayed 1230 seconds by postgrey-1.27 at vger.kernel.org; Sun, 01 Apr 2007 15:00:01 EDT
Message-ID: <460FFC5C.8090200@andrew.cmu.edu>
Date: Sun, 01 Apr 2007 14:39:24 -0400
From: James Bruce <bruce@andrew.cmu.edu>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/16] vt-pure-colors.diff
References: <Pine.LNX.4.61.0704011900470.8018@yvahk01.tjqt.qr> <Pine.LNX.4.61.0704012002330.12316@yvahk01.tjqt.qr>
In-Reply-To: <Pine.LNX.4.61.0704012002330.12316@yvahk01.tjqt.qr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> Have the Linux kernel set a new VGA palette for the first 16 colors.
> The new values reduce the saturation (white component) and therefore
> increase contrast.
<snip>

While the patch seems fine, this comment is not correct.  The patch is 
decreasing the *brightness* in order to *increase* saturation. 
Saturation[1] is the deepness of a color, not the white component 
(brightness, lightness).

  - Jim Bruce

[1] http://www.poynton.com/notes/colour_and_gamma/ColorFAQ.html#RTFToC6
