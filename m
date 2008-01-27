Return-Path: <linux-kernel-owner+w=401wt.eu-S1757344AbYA0VDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757344AbYA0VDS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 16:03:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754144AbYA0VDF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 16:03:05 -0500
Received: from rv-out-0910.google.com ([209.85.198.191]:54026 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753890AbYA0VDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 16:03:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=onjASnSLI5Ediee+1ZZRBFkYhVevk7jdRgx27+hULP1e4iAO0zuIjSNOHOsq8RLViVX0esoxDYB3gHsz/9gw+WsTmVfKqM49Mp5AxS+TylzwINeBpNH5XYpHVBfvQb+Kn+Tsi3NfNA/RMKvUbKo99UBa4TX6JH0Hiw1ID3KTf7I=
Message-ID: <84144f020801271303w4d8c1fe9tbf7058ac518d4d29@mail.gmail.com>
Date: Sun, 27 Jan 2008 23:03:00 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: trenn@suse.de
Subject: Re: [PATCH] Allocate pnp resources dynamically via krealloc - working version
Cc: linux-acpi@vger.kernel.org, "Len Brown" <lenb@kernel.org>,
       "Bjorn Helgaas" <bjorn.helgaas@hp.com>,
       "Rene Herman" <rene.herman@keyaccess.nl>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Jean Delvare" <khali@linux-fr.org>
In-Reply-To: <1201109917.20940.214.camel@queen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1200772810.3708.42.camel@queen>
	 <84144f020801191623i2ad344a8t1c40969578793d13@mail.gmail.com>
	 <1201109917.20940.214.camel@queen.suse.de>
X-Google-Sender-Auth: d59892cc84741d3a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

On Sun, 2008-01-20 at 02:23 +0200, Pekka Enberg wrote:
> > When krealloc() returns NULL, there wasn't enough memory to fit the
> > new size but the original memory region remains unchanged.

On Jan 23, 2008 7:38 PM, Thomas Renninger <trenn@suse.de> wrote:
> Thanks Pekka, this one should be better now:

Yeah, the krealloc() bits look good me. Thanks!

                         Pekka
