Return-Path: <linux-kernel-owner+w=401wt.eu-S1755042AbYK2VDV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755042AbYK2VDV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 16:03:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752614AbYK2VDM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 16:03:12 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:45370 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752557AbYK2VDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 16:03:11 -0500
Date: Sat, 29 Nov 2008 21:03:02 +0000
From: Matthew Garrett <mjg@redhat.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jamie Lokier <jamie@shareable.org>,
       =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
       Matthew Wilcox <matthew@wil.cx>, Christoph Hellwig <hch@infradead.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, mingo@redhat.com, val.henson@gmail.com
Subject: Re: [PATCH v2 2/2] relatime: Allow making relatime the default behaviour
Message-ID: <20081129210302.GB22998@srcf.ucam.org>
References: <20081127150126.GA20941@srcf.ucam.org> <20081127150341.GB20941@srcf.ucam.org> <20081127170345.GA14991@infradead.org> <20081129002419.abfd2504.akpm@linux-foundation.org> <20081129130308.GX25548@parisc-linux.org> <20081129135742.GC11959@logfs.org> <20081129185645.GA20194@shareable.org> <20081129190245.GA21502@srcf.ucam.org> <20081129123220.67fd1e6a.akpm@linux-foundation.org> <20081129125529.0198e973@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081129125529.0198e973@infradead.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 29, 2008 at 12:55:29PM -0800, Arjan van de Ven wrote:

> let me ask this:
> Has anmyone ever had the desire to change the default of 1 day of
> relatime? Ever?

The current kernel code has no time-based heuristics. It'll only update 
atime if it's older than ctime or mtime.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
