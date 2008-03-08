Return-Path: <linux-kernel-owner+w=401wt.eu-S1760065AbYCHSko@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760065AbYCHSko (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2008 13:40:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754935AbYCHSkd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Mar 2008 13:40:33 -0500
Received: from wf-out-1314.google.com ([209.85.200.174]:21390 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755137AbYCHSkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2008 13:40:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=VGoPuTO01Q+QHw2bJiVsY/zVIdiTRAp0a+LmwkFiOfht4W9uDxVwffLMaTt5jENxkF/vgGLPtdcQGk56cbfa364r/iiE02xV9SqC1wTNYdJ5LfFB1cLOpvovlnnlvyDIeUShfaXjl5HZCplVDKpoyF8d/ty5VJC4Fp1kZ10AOvQ=
Message-ID: <e9e943910803081040n78898f20t66a5f8396e63acbe@mail.gmail.com>
Date: Sat, 8 Mar 2008 18:40:30 +0000
From: "Duane Griffin" <duaneg@dghda.com>
To: "Christoph Hellwig" <hch@infradead.org>
Subject: Re: [RFC, PATCH 4/6] jbd: refactor nested journal log recovery loop into separate functions
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Theodore Tso" <tytso@mit.edu>, sct@redhat.com,
       akpm@linux-foundation.org, adilger@clusterfs.com
In-Reply-To: <20080308145351.GB18522@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a047dfbd7855d5f484ae8a3434f6a073302505be.1204685366.git.duaneg@dghda.com>
	 <8644b32ddec999bbc1da0ac55ad7b66d0b8176de.1204685366.git.duaneg@dghda.com>
	 <20080308145351.GB18522@infradead.org>
X-Google-Sender-Auth: 51a921900109ae5e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03/2008, Christoph Hellwig <hch@infradead.org> wrote:
> On Thu, Mar 06, 2008 at 01:59:12AM +0000, Duane Griffin wrote:
>  > +static int replay_data_block(
>  > +     journal_t *journal, struct buffer_head *obh, char *data,
>  > +     int flags, unsigned long blocknr)
>
> quite odd formatting, this should be more like:
>
>  static int replay_data_block(journal_t *journal, struct buffer_head *obh,
>                 char *data, int flags, unsigned long blocknr)
>
> (same for the other new helpers)

OK, will change.

Thanks,
Duane.

-- 
"I never could learn to drink that blood and call it wine" - Bob Dylan
