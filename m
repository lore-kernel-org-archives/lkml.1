Return-Path: <linux-kernel-owner+w=401wt.eu-S1751263AbXBZLtK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751263AbXBZLtK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 06:49:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751262AbXBZLtK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 06:49:10 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:53245 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263AbXBZLtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 06:49:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ipMTcFmS0EGT0J+iQ58XvrXQOR/QrPO4y90hKS0rhl+zOdhp9q2dETO83UkTP6lJBcb2zSoRADITQpk3pYYNNetuzH6z9KWDDtampwEYh/lzGZqrubGx6SlClqiMG7RrwzUqFonOBE55D7+UDacW+6Pt/DnBtcs9tX4gRMLTxj8=
Message-ID: <f36b08ee0702260349p284f0886n7a1987cfdd43bf55@mail.gmail.com>
Date: Mon, 26 Feb 2007 06:49:05 -0500
From: "Yakov Lerner" <iler.ml@gmail.com>
To: sfaibish <sfaibish@emc.com>
Subject: Re: [ANNOUNCE] DualFS: File System with Meta-data and Data Separation
Cc: "kernel list" <linux-kernel@vger.kernel.org>,
       "piernas@ditec.um.es" <piernas@ditec.um.es>
In-Reply-To: <op.tnrbrocsunckof@usensfaibisl2e.eng.emc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <op.tnkdlbgsrwwil4@brcsmondepl2c.corp.emc.com>
	 <op.tnrbrocsunckof@usensfaibisl2e.eng.emc.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/14/07, sfaibish <sfaibish@emc.com> wrote:
> On Sat, 10 Feb 2007 22:06:37 -0500, Sorin Faibish <sfaibish@emc.com> wrote:
>
> > Introducing DualFS
> >
> > File System developers played with the idea of separation of
> > meta-data from data in file systems for a while. The idea was
> > lately revived by a small group of file system enthusiasts
> >  from Spain (from the little known University of Murcia) and
> > it is called DualFS. We believe that the separation idea
> > will bring to Linux file systems great value.
> >
> > We see DualFS as a next-generation journaling file system which
> > has the same consistency guaranties as traditional journaling
> > file systems but better performance characteristics. The new file
> > system puts data and meta-data on different devices (usually, two
> > partitions on the same disk or different disks)

Do you guys have an option of using just one partiton, and
divide it into two fixed parts at mkfs-time , one part X% (for metadata)
and  2nd part at (100-X)% (file file  blocks) ? Would not this option
be easier-to-administer choice for naive users ? Or, you do not
view your FS as an option for naive users in the first place ?

Yakov
