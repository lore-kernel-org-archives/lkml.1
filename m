Return-Path: <linux-kernel-owner+w=401wt.eu-S1751984AbYLUUF5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751984AbYLUUF5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 15:05:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751016AbYLUUFt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 15:05:49 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:51959 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005AbYLUUFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 15:05:48 -0500
Date: Sun, 21 Dec 2008 20:05:39 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Andrew Paprocki <andrew@ishiboo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, dz@debian.org,
       Federico Heinz <fheinz@vialibre.org.ar>,
       Andy Spencer <spenceal@rose-hulman.edu>
Subject: Re: i8k: fails to detect Dell XPS M1530, fails to get SMM BIOS version with force=1
Message-ID: <20081221200538.GA29772@srcf.ucam.org>
References: <76366b180812171634k6c5a25d6uad0de0d6c514ebb5@mail.gmail.com> <76366b180812171707j7ad58957xf153d40efb7c7d59@mail.gmail.com> <20081217222221.ac2c6f3a.akpm@linux-foundation.org> <76366b180812172353o4f4fce30taac753a52a2a6e3e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <76366b180812172353o4f4fce30taac753a52a2a6e3e@mail.gmail.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My understanding is that the documented way of making SMM calls on any 
Dell system is using the interface in the dcdbas driver. dell-laptop 
uses this to export some of the information that i8k handles (and a 
bunch of other stuff) but not all of it. Asking about fan information on 
the libsmbios mailing list might get us the documented access method for 
that, and then dell-laptop can be extended to export that ia the hwmon 
interface.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
