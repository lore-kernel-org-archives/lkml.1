Return-Path: <linux-kernel-owner+w=401wt.eu-S1753666AbXDKVRi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753666AbXDKVRi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 17:17:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753668AbXDKVRi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 17:17:38 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:21921 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753662AbXDKVRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 17:17:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=RHO7XSk9GwZFWQRmeUJdI+WpBRCzbrxWwMAwCuCcqfhxLK6rg2RB56BF6WcmtLTHOOYL5PwsCJVffMZ/H5tKP6JL0/AaLZEHnsejL6vR41DjYdbK64gb6kJ66nJHxhsfNOseq1cTXTu1HRnK2poefUbVP0Egm/R+TQaO0AbOCKY=
Message-ID: <461D5070.7080902@gmail.com>
Date: Wed, 11 Apr 2007 23:17:36 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, corentincj@iksaif.net,
       sziwan@users.sourceforge.net, acpi4asus-user@lists.sourceforge.net,
       len.brown@intel.com, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 1/1] ACPI: asus_acpi, support F2JE model
References: <2189310342910921713@karneval.cz>	<20070411132053.899462b4.akpm@linux-foundation.org>	<461D45CE.3030309@gmail.com>	<461D46EF.2040805@gmail.com> <20070411140655.6dd2cb3f.akpm@linux-foundation.org>
In-Reply-To: <20070411140655.6dd2cb3f.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95b
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton napsal(a):
> On Wed, 11 Apr 2007 22:37:03 +0200
> Jiri Slaby <jirislaby@gmail.com> wrote:
> 
>> Jiri Slaby napsal(a):
>>> Side note, as Danny wrote, there is an asus-laptop driver sitting in -mm,
>>> which supersedes this one -- if you plan to push it upstream in the near
>>> future, don't bother with this patch.
>> Hmm, there is a 0.40 version in -rc6 yet. There is something weird with me
>> today.
>>
> 
> I don't know what you mean by this.

Oh, 0.40 version, which is in 2.6.21-rc6's drivers/misc/ directory would
"contain" the changes, which are in my patch -- so I thought it's useless,
but the driver is still marked as EXPERIMENTAL, so:

> If your patch is still good then I'd be inclined to proceed with it - yes,
> there's a new driver in Len's tree but I assume we'll be maintaining the
> old one until the new one is proven to be a successful replacement.

as you wrote, we might want the patch for the old one to go through if
nobody has objections.

thanks, sorry for the confusion,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
 B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E
