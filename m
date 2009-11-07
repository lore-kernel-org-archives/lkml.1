Return-Path: <linux-kernel-owner+w=401wt.eu-S1751516AbZKGK0p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751516AbZKGK0p (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Nov 2009 05:26:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751425AbZKGK0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Nov 2009 05:26:45 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:53828 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389AbZKGK0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Nov 2009 05:26:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=JBWyhZx9vWGvUIL1qbs10VmbE8WUtHXYCsdi3oGTh7voY4RIy7qketp7LwHdGJsism
         mRs3ahTmIVa3r9zeYCHanL/9EWw3hQucN8jDqi330JOIFGk+HdoocTsA2pCtoxXoBerW
         +EnFth6HyF+qaK/VdV24vW57xn8qlPNBMaEYg=
Message-ID: <4AF54B77.2000605@gmail.com>
Date: Sat, 07 Nov 2009 11:27:03 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.5pre) Gecko/20091028 SUSE/3.0b4-5.1 Thunderbird/3.0pre
MIME-Version: 1.0
To: Rakib Mullick <rakib.mullick@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -mm] char, moxa: Make isabrds variable global.
References: <b9df5fa10911022029q197a0c5dkbbda609f4e41287@mail.gmail.com> <b9df5fa10911062108l2334be64ka0777e89c6dbc17f@mail.gmail.com>
In-Reply-To: <b9df5fa10911062108l2334be64ka0777e89c6dbc17f@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/2009 06:08 AM, Rakib Mullick wrote:
> On 11/3/09, Rakib Mullick <rakib.mullick@gmail.com> wrote:
>>  When CONFIG_MODULE=n and CONFIG_PCI=n, then variable
>>  isabrds becomes unused variable. So place it outside
>>  moxa_init solves this problem.
>>
>>   We were warned by the following warning:
>>
>>  drivers/char/moxa.c: In function `moxa_init':
>>  drivers/char/moxa.c:1012: warning: unused variable `isabrds'
> 
> Hi Andrew, after applying this one, it introduce a new warning:

Sorry I had no time to look into the first patch. And it makes no sense.
The driver is unusable on !MODULE && !PCI. So better fix is to disallow
whole build on such configurations. Care to fix that?
