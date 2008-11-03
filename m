Return-Path: <linux-kernel-owner+w=401wt.eu-S1756406AbYKCPLO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756406AbYKCPLO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 10:11:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754379AbYKCPK6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 10:10:58 -0500
Received: from wf-out-1314.google.com ([209.85.200.175]:21244 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754343AbYKCPK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 10:10:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=FBl/BhGVSAJ9m8TROWx5/kGIVhGnTnKqZE/ANf5pa75duf60Laqt66npOoRgB7k6hv
         z2CZP2BOZJu3Hor19nmtdxWy2BI05L81yJ0PQpl2vYikGGT2B1HT5AVh4t+vibqtw9vW
         ihbByh+c23sPkFNcz8utKhVPu7daphLgFAfko=
Message-ID: <dd18b0c30811030710x6fd511a1ya6427f56d722bcd0@mail.gmail.com>
Date: Mon, 3 Nov 2008 07:10:56 -0800
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Fabio Comolli" <fabio.comolli@gmail.com>
Subject: Re: ACPI Warning (nspredef-0858): \_SB_.BAT0._BIF:
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <b637ec0b0811030628x78ff7f4dgfed3c657882b9af2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <dd18b0c30811030624o2d8fe46u1e3e82d6f6b94481@mail.gmail.com>
	 <b637ec0b0811030628x78ff7f4dgfed3c657882b9af2@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 3, 2008 at 6:28 AM, Fabio Comolli <fabio.comolli@gmail.com> wrote:
> http://bugzilla.kernel.org/show_bug.cgi?id=11822
>
>
>
> On Mon, Nov 3, 2008 at 3:24 PM, Justin Mattock <justinmattock@gmail.com> wrote:
>> Hmm,
>> This is weired; I'm not sure but I think this might
>> be caused by acpid or something in that area, i.g.
>> doing a fresh install and loading the latest git leaves me
>> without a warning message, but then after upgrading to intrepid
>> I see this:
>> [   11.116543] ACPI Warning (nspredef-0858): \_SB_.BAT0._BIF: Return
>> Package type mismatch at index 9 - found Buffer, expected String
>> [20080926]
>>
>>
>> --
>> Justin P. Mattock
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
>

Well, I guess a safe solution, until this is fixed
for me at least is to just use the
acpi_osi=Darwin boot option.

-- 
Justin P. Mattock
