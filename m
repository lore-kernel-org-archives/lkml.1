Return-Path: <linux-kernel-owner+w=401wt.eu-S1755301AbZHTTaE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755301AbZHTTaE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 15:30:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751984AbZHTTaD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 15:30:03 -0400
Received: from mail-yw0-f173.google.com ([209.85.211.173]:60317 "EHLO
	mail-yw0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913AbZHTTaB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 15:30:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=Obxfv3kxPw7hl9q9Kv0OpBdok0qDn8iD4VxLcJDyHE21gTO8MlxVf8Z4/WYEtvZ/vg
         15kcI8hQf3oP2efUY/QNCNCmQsR1IO4rZFirTL3OTMpAR/VwabwYzLNJPVkrLxIzIW0P
         5KJ3yWdgqIxJRMElsSZ7O8zce8WPN//xTBPDM=
MIME-Version: 1.0
In-Reply-To: <1250755318.8974.26.camel@macbook.infradead.org>
References: <bug-14003-10286@http.bugzilla.kernel.org/> <20090819142634.0fc550d1.akpm@linux-foundation.org> 
	<1250754748.8974.17.camel@macbook.infradead.org> <1250755318.8974.26.camel@macbook.infradead.org>
From: Ray Lee <ray-lk@madrabbit.org>
Date: Thu, 20 Aug 2009 12:29:42 -0700
X-Google-Sender-Auth: 640bfa56487effcd
Message-ID: <2c0942db0908201229o6ba670ebqda4d7cfc72d0ece8@mail.gmail.com>
Subject: Re: [PATCH] intel-iommu: Work around yet another BIOS bug
To: David Woodhouse <dwmw2@infradead.org>
Cc: torvalds@linux-foundation.org, Andrew Morton <akpm@linux-foundation.org>,
       Faidon Liambotis <paravoid@debian.org>,
       Matt Domsch <Matt_Domsch@dell.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       bugzilla-daemon@bugzilla.kernel.org, bugme-daemon@bugzilla.kernel.org,
       bero@arklinux.org, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 20, 2009 at 1:01 AM, David Woodhouse <dwmw2@infradead.org> wrote:
> +       if (iommu->cap == (uint64_t)-1 && iommu->ecap == (uint64_t)-1) {
> +               /* Promote an attitude of violence to a BIOS engineer today */
> +               WARN(1, "Your BIOS is broken; DMAR reported at address %llx returns all ones!\n"

Think about changing this to a warning that "Your IOMMU appears to be
disabled." All ones is, after all, the traditional hint that the
device is turned off.
