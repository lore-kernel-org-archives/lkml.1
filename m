Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753467AbYLRBHU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467AbYLRBHU (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 20:07:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752769AbYLRBHG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 20:07:06 -0500
Received: from wf-out-1314.google.com ([209.85.200.174]:38224 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752761AbYLRBHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 20:07:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=X0kQwHSNsTX6eDY/P/FqPrVjTpArqhYDuvtc2TINq2fVbOPcg+zpViL0SaaAW0uSrZ
         4R/HwLjB6H75TdG+fbZKyFrMwtjv2FK8X9mDj4bLdw28wJ0oBhjxBiT4JwkHxwGB84eq
         a5wJbN1EYkvJtZ9Ik7OBbQKI878zm1wpGgaqg=
Message-ID: <76366b180812171707j7ad58957xf153d40efb7c7d59@mail.gmail.com>
Date: Wed, 17 Dec 2008 20:07:02 -0500
From: "Andrew Paprocki" <andrew@ishiboo.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: i8k: fails to detect Dell XPS M1530, fails to get SMM BIOS version with force=1
Cc: dz@debian.org, "Federico Heinz" <fheinz@vialibre.org.ar>,
        "Andy Spencer" <spenceal@rose-hulman.edu>
In-Reply-To: <76366b180812171634k6c5a25d6uad0de0d6c514ebb5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <76366b180812171634k6c5a25d6uad0de0d6c514ebb5@mail.gmail.com>
X-Google-Sender-Auth: 17f6797aee8d4d38
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2008 at 7:34 PM, Andrew Paprocki <andrew@ishiboo.com> wrote:
> I see two problems with the i8k module and the Dell XPS M1530. First,
> the laptop is not detected. Second, even if it is detected, the module
> prints that it is unable to get the SMM BIOS version even though the
> module appears to be working:

It appears that the Dell Vostro & Precision series have the same issue
and the driver was never updated for those as well. Patches were
submitted back in 2007-11 and 2008-04 respectively:

http://marc.info/?l=linux-kernel&m=119401935026583&w=2
http://marc.info/?l=linux-kernel&m=120822526223412&w=2

The same message prints for (at least one of) those as well:

i8k: unable to get SMM BIOS version

-Andrew
