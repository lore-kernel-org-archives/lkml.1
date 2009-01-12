Return-Path: <linux-kernel-owner+w=401wt.eu-S1756492AbZALTXV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756492AbZALTXV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 14:23:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753952AbZALTXL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 14:23:11 -0500
Received: from mail-ew0-f17.google.com ([209.85.219.17]:42932 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752978AbZALTXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 14:23:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=a7MtX1TpZf1jnVdAEmQ0ZaJkkeM30A6CBotnM4Z5D4GfY4WvmMz0mw2JgxmsLWdMCp
         y6cMLE0rMAL16Layh6Ue0JQF+eHYnCTo3EWPjMWadePD7z9NRh/5ABEwBsR4FA+zciN1
         H8y5SYYbhQu97KBlCMOfJufu+KK5TcOVHg2EI=
Message-ID: <524f69650901121123i1765dc3fye3ce636c91dd25bd@mail.gmail.com>
Date: Mon, 12 Jan 2009 13:23:07 -0600
From: "Steve French" <smfrench@gmail.com>
To: "Greg KH" <gregkh@suse.de>
Subject: Re: linux-next: Tree for January 12 (cifs vs. staging)
Cc: "Randy Dunlap" <randy.dunlap@oracle.com>,
       "Stephen Rothwell" <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, sfrench@samba.org
In-Reply-To: <20090112191330.GC7111@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20090112154539.4857f533.sfr@canb.auug.org.au>
	 <496B899E.7060605@oracle.com>
	 <524f69650901121058g73c8022eif1d1bcca5c0e01fa@mail.gmail.com>
	 <20090112191330.GC7111@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is there some magic compile option alternative (other than renaming
the function, which may be ok, since others probably don't depend on
it)?  MD5Init is used outside fs/cifs/md5.c so can't be static

On Mon, Jan 12, 2009 at 1:13 PM, Greg KH <gregkh@suse.de> wrote:
> On Mon, Jan 12, 2009 at 12:58:42PM -0600, Steve French wrote:
>> There is not just the cifs md5 one (which has been around a long
>> time), but an md5_init (static) in crypto and the new one in rt.  The
>> addition of the new one (rt md5_init) causes the build problem.   It
>> would be nice if we could use the same md5 routines though ... last
>> time we checked the crypto one was not well suited for calculating
>> signatures as a network fs would do though.
>
> I'll fix up the staging rt drivers to not do this, but cifs shouldn't be
> declaring such functions as globals either :)
>
> thanks,
>
> greg k-h
>



-- 
Thanks,

Steve
