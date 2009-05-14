Return-Path: <linux-kernel-owner+w=401wt.eu-S1756237AbZENNi6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756237AbZENNi6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 09:38:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752114AbZENNit
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 09:38:49 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:57298 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615AbZENNis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 09:38:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=LRt5CWNFZKfQ9cREMqr0NVAGh2sl/hymVepiZ99raXD/02YTlb76fCyqPwq0Hr/BKS
         i35jZHYVN+knvYU7UmQJprvHLauUSAM7dSMEPbUvb+bXOgooKNd8MC5ACL1I2oTblbuS
         7IjY3VMEXVyT8p/uwUrwdzI5AMGKKwn523gNA=
MIME-Version: 1.0
In-Reply-To: <1242277453.23058.35.camel@brick>
References: <200904301408.09370.tobias.doerffel@gmail.com>
	 <877i0xib7d.fsf@basil.nowhere.org>
	 <a36005b50905120720p14e0ea0av79f99551262a920a@mail.gmail.com>
	 <20090512150408.GH19296@one.firstfloor.org>
	 <a36005b50905121045s62c16760p3aba003647a572c7@mail.gmail.com>
	 <1242277453.23058.35.camel@brick>
Date: Thu, 14 May 2009 06:38:48 -0700
Message-ID: <a36005b50905140638r56f73095kfc669bae1333e2bd@mail.gmail.com>
Subject: Re: Specific support for Intel Atom architecture
From: Ulrich Drepper <drepper@gmail.com>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Tobias Doerffel <tobias.doerffel@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 13, 2009 at 10:04 PM, Harvey Harrison
<harvey.harrison@gmail.com> wrote:
> It's called be16_to_cpup, or on x86, swab16p()

Indeed.  If now somebody with an Atom could test whether using movbe
has an advantage (my guess is that there is a slight advantage) then
one could define a special version of the __beXX_to_cpup and
__cpu_to_beXXp functions for Atom and start using these functions more
rigorously in the tree.
