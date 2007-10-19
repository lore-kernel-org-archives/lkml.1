Return-Path: <linux-kernel-owner+w=401wt.eu-S1762186AbXJSK21@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762186AbXJSK21 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 06:28:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754009AbXJSK2S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 06:28:18 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:31323 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752453AbXJSK2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 06:28:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=XQaTYxz5hazKjSK4x0BeCFYtnX/FAYfXqpxGZ+cTNtTHtb2Wba/24pN/5EXSDroiKdnQJaHPfzitigv+5v3ttECrYg6qX+BfGmSfJxlu0YSAVnf3e2Wz/kMR8nc1wjCELE9qAYXDj/yXUqYhQtsfBfm5/M2FX1BCTb1MlPhnzCc=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH] ia64 vDSO vs --build-id
Date: Fri, 19 Oct 2007 11:28:07 +0100
User-Agent: KMail/1.9.1
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-ia64@vger.kernel.org, tony.luck@intel.com,
       Doug Chapman <dchapman@redhat.com>
References: <20071018221108.638644D04E2@magilla.localdomain>
In-Reply-To: <20071018221108.638644D04E2@magilla.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710191128.08252.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 18 October 2007 23:11, Roland McGrath wrote:
> When gcc uses --build-id by default, the gate.lds.S linker script runs afoul
> of the new note section and produces a bad DSO image.  This fixes it.

I wonder why we bother having --build-id.
--
vda
