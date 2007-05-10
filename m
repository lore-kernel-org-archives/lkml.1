Return-Path: <linux-kernel-owner+w=401wt.eu-S1760928AbXEJQ1g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760928AbXEJQ1g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 12:27:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760376AbXEJQ12
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 12:27:28 -0400
Received: from merkurneu.hrz.uni-giessen.de ([134.176.2.3]:50474 "EHLO
	merkurneu.hrz.uni-giessen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760351AbXEJQ11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 12:27:27 -0400
X-Greylist: delayed 901 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 May 2007 12:27:26 EDT
From: Marc Dietrich <Marc.Dietrich@ap.physik.uni-giessen.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.21-mm2
Date: Thu, 10 May 2007 18:11:35 +0200
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <20070509012322.199f292b.akpm@linux-foundation.org>
In-Reply-To: <20070509012322.199f292b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705101811.43635.marc.dietrich@ap.physik.uni-giessen.de>
X-HRZ-JLUG-MailScanner-Information: Passed JLUG virus check
X-HRZ-JLUG-MailScanner: No virus found
X-MailScanner-From: marc.dietrich@ap.physik.uni-giessen.de
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

Am Wednesday 09 May 2007 10:23 schrieb Andrew Morton:
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21/2.6.21
>-mm2/
>
>
> - git-acpi was temporarily dropped due to git conflicts which I didn't feel
>   like fixing.
>
> - So was git-kvm
>
> - A handful of IDE patches were dropped due to compilation failures.  Bart
>   may have fixed this since I last downloaded his tree..
>
> - The adaptive readahead patches were dropped.  We're expecting a new, much
>   simpler version of these.

since -mm1 I cannot create files on nfs4 shares. 

#me@localhost:/home: touch t
touch: setting times of `t': Input/output error
#me@localhost:/home: dmesg|tail -n1
decode_attr_group: reply buffer overflowed in line 2676.

This problem was reported before in a different thread, but no reaction....

http://marc.info/?l=linux-kernel&m=117837974628893&w=2

thanks

Marc

-- 
	"The enemy commits atrocities knowingly; if we make unfortunate mistakes, it 
is involuntary."
		 Lord Arthur Ponsonby, "Falsehood in Wartime: Propaganda Lies of the First 
World War", 1928
