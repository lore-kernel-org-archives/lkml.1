Return-Path: <linux-kernel-owner+w=401wt.eu-S1757732AbZAMPVg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757732AbZAMPVg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 10:21:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755792AbZAMPVU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 10:21:20 -0500
Received: from wa-out-1112.google.com ([209.85.146.179]:57100 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755116AbZAMPVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 10:21:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=uhUhNE51HXyuStTcSxKJt91hYO5J0tPVnCxUFDl1q2CPHm9tTn0uM54z6OWm//R9cp
         94FRQaXhtmJX5eDoDuza9tgrtbM/DjikyVsikdcQwvaBtH+Yw509JwR68F1ghfnA9bgv
         xCw+KZQzjCqoijxJvGUNedz130GVvDIaon2hw=
Message-ID: <b6a2187b0901130721y51b9618uef6efb84b7784d6@mail.gmail.com>
Date: Tue, 13 Jan 2009 23:21:17 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Pavel Machek" <pavel@suse.cz>
Subject: Re: 2.6.29-rc1: thinkpad problems during resume
Cc: "kernel list" <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <20090113143646.GB1983@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20090113081316.GA2292@elf.ucw.cz>
	 <20090113143646.GB1983@elf.ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2009 at 10:36 PM, Pavel Machek <pavel@suse.cz> wrote:
> resumes fine with CONFIG_SMP unset.

On my X60s, I had problem with s2ram, and I switch to the following ...

echo mem > /sys/power/state

Try and see if it works for you.

Thanks,
Jeff.
