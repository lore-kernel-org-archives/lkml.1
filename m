Return-Path: <linux-kernel-owner+w=401wt.eu-S1161093AbXCNKmA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161093AbXCNKmA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 06:42:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161110AbXCNKmA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 06:42:00 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:48304 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161093AbXCNKl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 06:41:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=DnpvvTfsv94KWLybfhSqyFw+2g+mjKDYat3v3ef+InQbByrspNQw5+ncH5U4fG46KShIL1SJxnt6BMKcv7JkBxAbGnXaf4X2E+h2MKDu6mqdhK5gFeJgYWBHDZjHFyupXi9Mtl0JeFTj6R55lz/mrufsTJrmrciidtzJOTgWk40=
Message-ID: <84144f020703140341p322d9dc5wb9edc37bf923685d@mail.gmail.com>
Date: Wed, 14 Mar 2007 12:41:51 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Marco Berizzi" <pupilla@hotmail.com>
Subject: Re: kernel BUG at mm/slab.c:610
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <BAY103-DAV1337A9B2136C6C89DC0C0DB2730@phx.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <BAY103-DAV1337A9B2136C6C89DC0C0DB2730@phx.gbl>
X-Google-Sender-Auth: ed26d015c1e2956f
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marco,

On 3/14/07, Marco Berizzi <pupilla@hotmail.com> wrote:
> Hello everybody. Sorry for posting to this list, but I'm pretty lost.

Don't worry, this is the proper mailing list for bug reports.

On 3/14/07, Marco Berizzi <pupilla@hotmail.com> wrote:
> I don't think this is related to buggy hardware because it is happening
> on 3 different boxes with the same hardware config.

No, looks like someone is feeding a bad pointer to slab. The debug
check is relatively new and in previous kernels the problem would
might have gone unnoticed causing silent corruption of the slab.

On 3/14/07, Marco Berizzi <pupilla@hotmail.com> wrote:
> ksymoops 2.4.10 on i686 2.6.20.  Options used

>From Documentation/oops-tracing.txt:

"NOTE: ksymoops is useless on 2.6.  Please use the Oops in its original format
 (from dmesg, etc).  Ignore any references in this or other docs to "decoding
 the Oops" or "running it through ksymoops".  If you post an Oops from 2.6 that
 has been run through ksymoops, people will just tell you to repost it."

So, can you please repost the original oops? Also, please enable
CONFIG_DEBUG_SLAB  and try to reproduce. Thanks.
