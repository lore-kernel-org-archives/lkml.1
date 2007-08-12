Return-Path: <linux-kernel-owner+w=401wt.eu-S964834AbXHLUs5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964834AbXHLUs5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 16:48:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934146AbXHLUsm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 16:48:42 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:48372
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754623AbXHLUsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 16:48:40 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: "Jesper Juhl" <jesper.juhl@gmail.com>
Subject: Re: [PATCH 0/5] Add some missing Documentation/*/00-INDEX files
Date: Sun, 12 Aug 2007 15:48:35 -0500
User-Agent: KMail/1.9.6
Cc: "Stefan Richter" <stefanr@s5r6.in-berlin.de>, linux-doc@vger.kernel.org,
       "Randy Dunlap" <rdunlap@xenotime.net>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
References: <200708120045.03032.jesper.juhl@gmail.com> <46BF01A5.9060003@s5r6.in-berlin.de> <9a8748490708121010q7fe3bfbx8d4d8b997ed5fc72@mail.gmail.com>
In-Reply-To: <9a8748490708121010q7fe3bfbx8d4d8b997ed5fc72@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708121548.35810.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 12 August 2007 12:10:56 pm Jesper Juhl wrote:
> > Isn't it with 00-INDEX just like with the "Last Updated:" footers in
> > documentation texts?
>
> That is certainly a risk, yes. But it shouldn't be hard to write a
> small script to check if the 00-INDEX files are up-to-date, that will
> make it pretty simple to update them once in a while if people forget.

Already done:
http://marc.info/?l=linux-doc&m=118671778606001&w=2

It checks the index.html files so you have to run 
http://kernel.org/doc/make/docdiridx.py and then run 
http://kernel.org/doc/make/doclinkcheck.py afterwards.  It shows you the 
files 00-index links to which aren't there (the 404 errors), and then the 
files that nothing links to.

I notice that I'm not filtering out the generated index.html files, but oh 
well.  I'll fix that... :)

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
