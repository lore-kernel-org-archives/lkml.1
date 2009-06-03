Return-Path: <linux-kernel-owner+w=401wt.eu-S1756036AbZFCHXl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036AbZFCHXl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 03:23:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754592AbZFCHXc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 03:23:32 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:20548 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753725AbZFCHX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 03:23:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=B3EbBa2JESSuVWYF1QgvaRNK4pj2D9TjGTIounX7d6ZegWJN1YZYHtXb8n4y8UZ/Al
         z/gN2Bv9kcOxcKQb19aYZ0K7Cvb0JydMx/1Z015wklV3+VmA1hfSukplGHOGLq14XXcj
         l17XPWsfty9Y3EDhrR23DtMSl864IAK+OzRy4=
MIME-Version: 1.0
In-Reply-To: <20090603024453.GA28009@srcf.ucam.org>
References: <dd18b0c30906021102h43b8ecc4u9e67687de129bca1@mail.gmail.com>
	 <1243992286.9076.5.camel@rzhang-dt>
	 <dd18b0c30906021911u4c2359daje01b0477a6bd23ff@mail.gmail.com>
	 <20090603024453.GA28009@srcf.ucam.org>
Date: Wed, 3 Jun 2009 00:23:31 -0700
Message-ID: <dd18b0c30906030023u6dd089e3l1df3f1b1ee3ff4e@mail.gmail.com>
Subject: Re: ACPI Exception (evregion-0422): AE_ERROR, Returned by Handler for 
	[PCI_Config] [20090320]
From: Justin Mattock <justinmattock@gmail.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Zhang Rui <rui.zhang@intel.com>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 2, 2009 at 7:44 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> On Tue, Jun 02, 2009 at 07:11:41PM -0700, Justin Mattock wrote:
>
>> alright(Ill have to do that when I get a chance)
>> As for the error message after looking into it more today
>> I notice this message fired off as soon as I compiled
>> and loaded the nvidia module.
>
> It looks like the nvidia driver is triggering an evaluation of the _PS0
> method on your graphics hardware. This ought to just power up your
> hardware. In the process it's trying to write to PCI configuration
> space, and some kind of error is being generated as a result - the debug
> output doesn't obviously make it possible to work out what.
>
> If your graphics hardware still works then it's not an issue, but
> there's the possibility that this is a Linux bug which might generate
> real problems in some other situation.
>
> --
> Matthew Garrett | mjg59@srcf.ucam.org
>

right now with 2.6.30-rc7(I'll have to load
*-rc8 in the next few days)
Everything seems to be running o.k.
(even with this error message)
under nvidia-settings the temperature
is at a comfortable number.

There is some issues when watching
movies on certain sites(but I think this is gtk+
related)
As for the kernel, I didn't check to see is acpi's video module
is loading or built-in(will look when I get a chance),
quit possibly causing some interference.
(but probably not)

In any case my main concern with the gpu is
to make sure that the temp stays at a good level,
and so far It has.

-- 
Justin P. Mattock
