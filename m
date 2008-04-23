Return-Path: <linux-kernel-owner+w=401wt.eu-S1753333AbYDWHbn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333AbYDWHbn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 03:31:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751217AbYDWHbe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 03:31:34 -0400
Received: from rv-out-0708.google.com ([209.85.198.247]:14893 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751205AbYDWHbd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 03:31:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=PSVY+7Hb3LhFUPSOXgNUXv6gO1fjqoQvNatFII8ROV8hPj3YbuH60wFQlA12s5rXV+JiDRUbd3TYe3QERU+Bg6JojF48ymsk4182y9dITm16cJD/SMuNDeJzPlySqWvvD7mdQvf47I+Giuljnu+kjDHO3CJFr3a4jkwBaI1FesQ=
Message-ID: <84144f020804230031w612176c1k8ec5a6fb27ca3315@mail.gmail.com>
Date: Wed, 23 Apr 2008 10:31:31 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Pete Zaitcev" <zaitcev@redhat.com>
Subject: Re: [sched-devel/latest] WARNING: at mm/slub.c:2443
Cc: "Ingo Molnar" <mingo@elte.hu>, "Frans Pop" <elendil@planet.nl>,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org, gregkh@suse.de,
       "Christoph Lameter" <clameter@sgi.com>
In-Reply-To: <20080422235148.c49dc6b7.zaitcev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200804212310.41729.elendil@planet.nl>
	 <20080422134034.GF7311@elte.hu>
	 <20080422235148.c49dc6b7.zaitcev@redhat.com>
X-Google-Sender-Auth: b534e1c317cab273
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pete,

On Wed, Apr 23, 2008 at 9:51 AM, Pete Zaitcev <zaitcev@redhat.com> wrote:
>  I looked at this whole day today, but found nothing.
>
>  The code analysis for usbmon shows nothing. Anyone wants to have
>  a look?

I didn't look too closely but mon_text_fetch() does list_del() but no
kmem_cache_free() which looks fishy.
