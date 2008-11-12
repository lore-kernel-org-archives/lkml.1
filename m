Return-Path: <linux-kernel-owner+w=401wt.eu-S1753980AbYKLPi3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753980AbYKLPi3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 10:38:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752753AbYKLPiV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 10:38:21 -0500
Received: from yw-out-2324.google.com ([74.125.46.29]:45602 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752735AbYKLPiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 10:38:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=E+VrB7SzldLmpMQ9XgixTUKQ4iKTE0lag5GNStiMcEcYTubu7gyNIBE195J0IBTjbq
         u4jCraVS/oh5VyNuDkIpYtFKoaEaALVm74CvstRZvnLSsmGus5hL/aMiipBexijndSMD
         o0rsiNpBF/ec2FY0W6plGYjLZZdiErBosKJIg=
Message-ID: <2f3bf9a60811120738s6082c9f1jdcc95820e3770b40@mail.gmail.com>
Date: Wed, 12 Nov 2008 17:38:17 +0200
From: "Dotan Barak" <dotanba@gmail.com>
To: "Andy Whitcroft" <apw@shadowen.org>
Subject: Re: checkpatch.pl print the line twice when trailing statements in the same line
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20081112135459.GC8302@shadowen.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200810202051.38694.dotanba@gmail.com>
	 <20081031082414.GD26593@brain> <20081112135459.GC8302@shadowen.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks.

I noticed another issue:

for the code line:
 return (int)0;

I get the following error message:
 ERROR: return is not a function, parentheses are not required.

Thanks
Dotan

On Wed, Nov 12, 2008 at 3:54 PM, Andy Whitcroft <apw@shadowen.org> wrote:
> On Fri, Oct 31, 2008 at 08:24:14AM +0000, Andy Whitcroft wrote:
>> On Mon, Oct 20, 2008 at 08:51:38PM +0200, Dotan Barak wrote:
>> > Hi.
>> >
>> > I executed checkpatch.pl version 0.24 on a file and i noticed that when
>> > a tailing statement is being declared at the same line with "while, checkpatch
>> > prints the erroneous line twice.
>> >
>> > Here is an example of the output:
>> >
>> > ERROR: trailing statements should be on next line
>> > #651: FILE: idbm.c:651:
>> > +               while (*nl && isspace(c = *nl)) nl++;
>> > +               while (*nl && isspace(c = *nl)) nl++;
>> >
>> > Is this is the expected behavior?
>>
>> No that would definintaly not be expected.  Will add it to my TODO list.
>
> Ok, this is now fixed up and should be in my next batch of updates.
>
> -apw
>
