Return-Path: <linux-kernel-owner+w=401wt.eu-S932241AbYFFWUT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932241AbYFFWUT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 18:20:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755561AbYFFWUE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 18:20:04 -0400
Received: from an-out-0708.google.com ([209.85.132.247]:54758 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754410AbYFFWUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 18:20:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Wi38eTbioMMpjnz45xzZviPV0Ptoo8jMf2y14HAKf2V3/AQ/ghx5ecl2CVjNDNPtBr
         j4izqVcecvFKoyjEMugnmmrMPF6Q4WXqQDZt58tODgWSgp4snjtLUnahgnx0rMA6sZXK
         bA0dXCs6acLKzZQIzg0PTHan/+2fG+rXDVTnA=
Message-ID: <dd18b0c30806061520p5ba91669g907a1100449c980a@mail.gmail.com>
Date: Fri, 6 Jun 2008 22:20:00 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Matthew Garrett" <mjg59@srcf.ucam.org>
Subject: Re: [PATCH] isight_firmware: Avoid crash on loading invalid firmware
Cc: "Andrew Morton" <akpm@linux-foundation.org>, greg@kroah.com,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
In-Reply-To: <20080606215020.GA21048@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <dd18b0c30806060137j7edc751se364ff21cfc8911b@mail.gmail.com>
	 <20080606110711.a9a6a4f6.akpm@linux-foundation.org>
	 <dd18b0c30806061110qd3100b4p1ee9f8ef493a56c6@mail.gmail.com>
	 <dd18b0c30806061138h69c87d6am898a4eb409d379e1@mail.gmail.com>
	 <20080606185548.GB8576@kroah.com>
	 <20080606192135.GA16727@srcf.ucam.org>
	 <20080606123511.38ffbdde.akpm@linux-foundation.org>
	 <20080606194856.GA17708@srcf.ucam.org>
	 <dd18b0c30806061414k6b7a2f04g87e7594066f0f015@mail.gmail.com>
	 <20080606215020.GA21048@srcf.ucam.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 6, 2008 at 9:50 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> On Fri, Jun 06, 2008 at 09:14:27PM +0000, Justin Mattock wrote:
>> Also not matlock(not the T.V. show). Now onto the status:  I think
>> there might be something going on with this patch, or the module
>> itself I keep getting ACPI EC: GPE storm
>> detected(http://bugzilla.kernel.org/show_bug.cgi?id=10724) , yesterday
>> I modified drivers/acpi/ec.c and was not receiving this message the
>> rest of the day, after applying the patch to isight_firmware and
>> loading, I'm receiving this message probably within 20 minutes of
>> being up. Now I'm not sure If it's because I modified ec.c, or not
>> that's causing this. I'll have to run a couple of experiments to see.
>> has anybody seen the same message?
>> regards;
>
> Yeah, I've seen that too. Pretty sure it's unrelated.
>
> --
> Matthew Garrett | mjg59@srcf.ucam.org
>

Alright,
and again thanks for the help,
 I'll keep you posted if I see anything.
regards;

-- 
Justin P. Mattock
