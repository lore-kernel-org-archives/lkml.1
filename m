Return-Path: <linux-kernel-owner+w=401wt.eu-S933429AbXBXIYX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933429AbXBXIYX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 03:24:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933433AbXBXIYX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 03:24:23 -0500
Received: from nf-out-0910.google.com ([64.233.182.187]:5993 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933429AbXBXIYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 03:24:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=VcGbLr/d9XDcvYi76Tjk9XOIlA/MIgR0RnLY8VGKCVRXRdHJyG+stFaheNicJDtSGvyvgx+BfTi57Q09/pnNJr0pSBeq4MTqL9gdMy5TO0wlESln+sIgOpcVhUGFFshxCAywrT8huEgz8aDBCPy+PSpAu+OHSnwbBHUkzpuPWE4=
Message-ID: <45a44e480702240024w30c0c2e2uaa01f3ed8f7457c2@mail.gmail.com>
Date: Sat, 24 Feb 2007 03:24:20 -0500
From: "Jaya Kumar" <jayakumar.lkml@gmail.com>
To: "Paul Mundt" <lethal@linux-sh.org>,
       "Jaya Kumar" <jayakumar.lkml@gmail.com>,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [RFC 2.6.20 1/1] fbdev,mm: Deferred IO and hecubafb driver
In-Reply-To: <20070223092237.GA16889@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070223063228.GA9906@localhost>
	 <20070223092237.GA16889@linux-sh.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/23/07, Paul Mundt <lethal@linux-sh.org> wrote:
> On Fri, Feb 23, 2007 at 07:32:28AM +0100, Jaya Kumar wrote:
> > This is a first pass at abstracting deferred IO out from hecubafb and
> > into fbdev as was discussed before:
> > http://marc.theaimsgroup.com/?l=linux-fbdev-devel&m=117187443327466&w=2
> >
> > Please let me know your feedback and if it looks okay so far.
> >
> How about this for an fsync()? I wonder if this will be sufficient for
> msync() based flushing, or whether the ->sync VMA op is needed again..
>

Looks fine to me.

Thanks,
jaya
