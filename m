Return-Path: <linux-kernel-owner+w=401wt.eu-S1756714AbZBXLbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756714AbZBXLbU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 06:31:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754631AbZBXLbJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 06:31:09 -0500
Received: from mail-bw0-f161.google.com ([209.85.218.161]:65346 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752803AbZBXLbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 06:31:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=JhGjXWaHS7gWhw4urBKHj6YhiiL2HJwH/NedYJRynHYOIOhTLamORYHwpmHR0CmxtB
         CVPcv2FMpSr6A2VUg9gGQVY/9pHGixNxtj+W045FJa1rzt4SvHG5PDrDQ3fjb8XDW9/u
         1H6hGPlwZ7oxrMJuOc0MCR+OM8jZQ5QxDFPtQ=
From: Corentin Chary <corentincj@iksaif.net>
To: Darren Salt <ds@youmustbejoking.demon.co.uk>
Subject: Re: [PATCH 2.6.29-rc4] Restore ACPI reporting via /proc/acpi/events for EeePC & other Asus laptops.
Date: Tue, 24 Feb 2009 12:31:02 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.28-gentoo; KDE/4.2.0; x86_64; ; )
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Len Brown <lenb@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Matthew Garrett <mjg@redhat.com>
References: <alpine.LFD.2.00.0902081251090.3048@localhost.localdomain> <5030E21460%linux@youmustbejoking.demon.co.uk> <5030E5F170%ds@youmustbejoking.demon.co.uk>
In-Reply-To: <5030E5F170%ds@youmustbejoking.demon.co.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902241231.02809.corentincj@iksaif.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 10 February 2009 15:54:56 Darren Salt wrote:
> The descriptions for the following two commits
>   2a7dc0d8c60325e9bf820900bf919430e5a419ab (asus-laptop)
>   2b25c9f01aa58d48129b2f93748dfb5d1f7ab0a2 (eeepc-laptop)
> say that events should ALSO be exported via netlink, but the effect is that
> they are INSTEAD exported via netlink. The latter commit breaks use of
> acpid on my EeePC 901.

Hi,
There was already two patch for that on the ml

http://patchwork.kernel.org/patch/7356/
http://patchwork.kernel.org/patch/7357/

Thanks

-- 
Corentin Chary
http://xf.iksaif.net
