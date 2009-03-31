Return-Path: <linux-kernel-owner+w=401wt.eu-S1762848AbZCaPcD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762848AbZCaPcD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 11:32:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760824AbZCaPbt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 11:31:49 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:51863 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761473AbZCaPbs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 11:31:48 -0400
From: "Hans-Peter Jansen" <hpj@urpla.net>
To: Arjan van de Ven <arjan@linux.intel.com>, gitster@pobox.com
Subject: Re: Linux 2.6.29
Date: Tue, 31 Mar 2009 17:30:06 +0200
User-Agent: KMail/1.9.10
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       linux-kernel@vger.kernel.org
References: <alpine.LFD.2.00.0903231617550.3032@localhost.localdomain> <200903310000.11522.hpj@urpla.net> <49D142AC.8090701@linux.intel.com>
In-Reply-To: <49D142AC.8090701@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200903311730.08088.hpj@urpla.net>
X-Provags-ID: V01U2FsdGVkX1/lgx8EgL78SjQI1Xy0FK2SLg8CtUYq1eLY8mm
 E5EQWgernVn6qGcNLjG1VZ6DBTetZoG1nS6K4SI6+ncGoSpGa/
 3yectGA6coT+VdOPdbIyA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 31. März 2009 schrieb Arjan van de Ven:
> Hans-Peter Jansen wrote:
> >
> > I always wonder, why Arjan does not intervene for his kerneloops.org
> > project, since your approach opens a window of uncertainty during the
> > merge window when simply using git as an efficient fetch tool.
>
> I would *love* it if Linus would, as first commit mark his tree as
> "-git0" (as per snapshots) or "-rc0". So that I can split the "final"
> versus "merge window" oopses.

..which is an important difference. I still vote for -pre for "preparation 
state" as -git0 does imply some sort of versioning, which *is* meaningless 
in this state.

Linus, this would be a small step for you, but makes a big difference for 
those of us, that miss it sorely. 

Junio: is it possible to automate this in git somehow: make sure, that the 
first commit after a release really happens for a "new" version (e.g. a 
version patch to Makefile)?

Pete
