Return-Path: <linux-kernel-owner+w=401wt.eu-S965047AbXHLTya@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965047AbXHLTya (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 15:54:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937414AbXHLTyW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 15:54:22 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:43135
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S936897AbXHLTyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 15:54:21 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH 0/5] Add some missing Documentation/*/00-INDEX files
Date: Sun, 12 Aug 2007 14:54:15 -0500
User-Agent: KMail/1.9.6
Cc: Jesper Juhl <jesper.juhl@gmail.com>, linux-doc@vger.kernel.org,
       Randy Dunlap <rdunlap@xenotime.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200708120045.03032.jesper.juhl@gmail.com> <9a8748490708121010q7fe3bfbx8d4d8b997ed5fc72@mail.gmail.com> <46BF44A6.7010401@s5r6.in-berlin.de>
In-Reply-To: <46BF44A6.7010401@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708121454.15856.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 12 August 2007 12:34:30 pm Stefan Richter wrote:
> Jesper Juhl wrote:
> > On 12/08/07, Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
> >> Isn't it with 00-INDEX just like with the "Last Updated:" footers in
> >> documentation texts?
> >
> > That is certainly a risk, yes. But it shouldn't be hard to write a
> > small script to check if the 00-INDEX files are up-to-date, that will
> > make it pretty simple to update them once in a while if people forget.
>
> Or use the first line of each text file to describe what the file is about.

The first line of "unicode.txt" is:
                 Last update: 2005-01-17, version 1.4

The first line of "keys.txt" (and keys-request-key.txt) is:
                         ============================

The first line of sx.txt is blank, although that's easy enough to work around.

Lots of first lines redundantly have the filename in them, others have 
trailing information like the first nonblank line of kref.txt:

> krefs allow you to add reference counters to your objects.  If you

This heuristic seems to need about as much cleanup as just fixing 00-INDEX.txt 
in all the directories.

> And BTW, if authors insist on "Last Updated:", make it a header rather
> than a footer.  Increases the chance that submitters remember to update it.

Why not just use the source control system to review the actual revision 
history of the file?

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
