Return-Path: <linux-kernel-owner+w=401wt.eu-S1761963AbYGBGQ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761963AbYGBGQ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 02:16:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755564AbYGBGQS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 02:16:18 -0400
Received: from an-out-0708.google.com ([209.85.132.251]:51826 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754996AbYGBGQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 02:16:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=l8oTk5+u2V7YiRom3ymNtZbSFme0aDIwAzjctCmwPjafKO0aOI+VYcS1tieaJfhKH9
         vddK4weH960W8Jcis3EHmqXP4zNRjit27rJL6HaouwCZCKrbTP5m146zEKAA+OVMSEgZ
         W1k3IHg/oHdp+GCJRapFhJBYHsSEj9IyMHAmc=
Message-ID: <dd18b0c30807012316u9fd43c9udc78dd9adcf273bd@mail.gmail.com>
Date: Wed, 2 Jul 2008 06:16:15 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Eduard - Gabriel Munteanu" <eduard.munteanu@linux360.ro>
Subject: Re: dsdt buggy acpi
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "ACPI Devel Maling List" <linux-acpi@vger.kernel.org>
In-Reply-To: <20080702082555.0959ef2b@linux360.ro>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <dd18b0c30806302339q7b3effybf8a7f619b009262@mail.gmail.com>
	 <200807011619.53339.rjw@sisk.pl>
	 <dd18b0c30807010918p48cfbe2bnb7e4a2bf00a01638@mail.gmail.com>
	 <20080702082555.0959ef2b@linux360.ro>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 2, 2008 at 5:25 AM, Eduard - Gabriel Munteanu
<eduard.munteanu@linux360.ro> wrote:
> On Tue, 1 Jul 2008 16:18:45 +0000
> "Justin Mattock" <justinmattock@gmail.com> wrote:
>
>> Cool; thanks.
>> I'll check that out and see where and how I can locate the dsdt
>> manufacture number,  then see if I can fix the broken dsdt error and
>> apply this to the kernel and see what happens.
>> regards;
>
> Just one note here: DSDTs have nothing to do with the kernel. This is
> just broken firmware. The most one can do _in-kernel_ is blacklist some
> functionality or create a workaround, but this only happens for widely
> used stuff. Broken DSDTs aren't widely used stuff, they are written by
> the machine's vendor (the laptop's manufacturer for example, but this
> could be different for desktops) and differ a lot from one machine to
> another.
>
>
>        Eduard
>

Cool, thanks for the info, As of right now I'm mainly trying to clean
up as much acpi errors that I can
find in my system, in hopes leading me to more info on fixing a bug(or
someone else).: http://bugzilla.kernel.org/show_bug.cgi?id=10724
For right now I have cleaned up all of the errors and warning from the
dsdt.dsl and have
 plugged in the new dsdt.hex into the kernel.(everything seems O.K).,
except for two messages I received
from running iasl
 i.g. I've google but found not very many results for this
No back ptr to Op: type 8
No back ptr to Op: type 8

After contemplating I decided to go ahead with the modified dsdt
irregardless of the: No back ptr to Op: type 8
message, but to my dismay I'm still receiving the BUG.  "gripes"
on a positive not creating a custom dsdt and loading it into the
kernel is "cake", figuring out how to fix the dsdt is a "bi*^h";
anyways If you or anybody knows what this means, please send a message.
regards;

-- 
Justin P. Mattock
