Return-Path: <linux-kernel-owner+w=401wt.eu-S936473AbXHOUuv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936473AbXHOUuv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 16:50:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758849AbXHOUuW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 16:50:22 -0400
Received: from web52504.mail.re2.yahoo.com ([206.190.48.187]:47340 "HELO
	web52504.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756153AbXHOUuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 16:50:20 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=6Ltg5g5WYyo6hzBU+0/YS2sAx8Mb1XNBGxzv17V8wquTyKObanjVP45LkgDvOwI86BwkdPxYdC/N4VDEsBjDey+2ugOAvyMufZxM8gXU1m21soyhedxFqkSP0MG4nKcEsfW+yXCpt7ORDj2Rqd8t9UVyyG35+sqtTuql58ZCtek=;
X-YMail-OSG: Jegkkq0VM1ko3UXpNhoF_lR3kNodS51P8GmtBLjJNkSCRcTY1SH.KjokJqDMCM3DblRTnNWRcXOD1C7xpahggx0tIgdRF1GrPWLINaSBZvdR8X7bx0gNKBTL48Acz.NligxLg6PXK_5R0jw-
Date: Wed, 15 Aug 2007 13:50:17 -0700 (PDT)
From: Marc Perkel <mperkel@yahoo.com>
Subject: Re: Thinking outside the box on file systems
To: Phillip Susi <psusi@cfl.rr.com>
Cc: Kyle Moffett <mrmacman_g4@mac.com>,
       Michael Tharp <gxti@partiallystapled.com>, alan <alan@clueserver.org>,
       LKML Kernel <linux-kernel@vger.kernel.org>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
In-Reply-To: <46C36580.5030006@cfl.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <920558.27414.qm@web52504.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Phillip Susi <psusi@cfl.rr.com> wrote:

> Marc Perkel wrote:
> > 
> > Kyle - you are still missing the point. chmod goes
> > away. File permissions goes away. Directories as
> you
> > know them goes away. 
> 
> You are missing the point Marc... open()ing a file
> will have to perform 
> a number of these pattern matches to decide if it is
> allowed or not... 
> this would be a HUGE overhead.
> 
> 

I don't see it as being any worse that what we have
now. To open a file you have to start at the bottom
and open each directory and evaluate the permissions
on the way to the file. In my system you have to look
up the permission of the string at each "/" separator.
Seems to me that every system would have these same
steps.




Marc Perkel
Junk Email Filter dot com
http://www.junkemailfilter.com


      ____________________________________________________________________________________
Park yourself in front of a world of choices in alternative vehicles. Visit the Yahoo! Auto Green Center.
http://autos.yahoo.com/green_center/ 
