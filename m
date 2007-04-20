Return-Path: <linux-kernel-owner+w=401wt.eu-S1767283AbXDTVxj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767283AbXDTVxj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 17:53:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767285AbXDTVxj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 17:53:39 -0400
Received: from an-out-0708.google.com ([209.85.132.251]:41842 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767283AbXDTVxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 17:53:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=V34yRtxhxeWvlgotdf3JjEtye5WUFp5GvxcMxzJ4lgmllZLtZTFLynODcEOfTRfYlXgDVguLxCSEWhazfCM154Md3YkrYa7eq7S4k3lIx8Iujv0f7+3p+iw5SxKqMqMqrvXKIfG2IGcCk/W1GiWOLk5ecVi5FwO4QwgddrPyh/0=
Message-ID: <1f1b08da0704201453i1b2388der1dfe778633fbf6ea@mail.gmail.com>
Date: Fri, 20 Apr 2007 14:53:37 -0700
From: "john stultz" <johnstul@us.ibm.com>
To: guilherme <guilherme@centralinf.com.br>
Subject: Re: 2.6.21-rc7: HPET enabled freeze my machine at boot
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <4627D7CF.3070002@centralinf.com.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4627D7CF.3070002@centralinf.com.br>
X-Google-Sender-Auth: 7750e0f668dbb036
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/19/07, guilherme <guilherme@centralinf.com.br> wrote:
> Hi,
>
> If i enable "High Resolution Timer Support", my machine stops here at boot:
>
> Clocksource tsc unstable (delta = -297340790165 ns)
> Time: hpet clocksource has been installed.
>
> If i disable HPET, it boots fine.

Hmmm.. What happens if you boot w/ clocksource=acpi_pm ?
