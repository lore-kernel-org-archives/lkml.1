Return-Path: <linux-kernel-owner+w=401wt.eu-S1761570AbYD3GnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761570AbYD3GnS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 02:43:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755716AbYD3GnE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 02:43:04 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:14631 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754916AbYD3GnB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 02:43:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=Gisa6eQnypuLTqVwvbSfP/VzS4x7daYcE19xRwxnKPXMfO1Ls1+pGefNxkG+fOgYQgqf1NhiOUZCx+VRz+kPD//5zp+Uq3BaCDBKax3FpxTmUbyIMYzTIaQ0jWfVuPeXBqTFi+aXyN0cegIrF84MbWL7G/UKLKUXxaqcc0IUp0w=
Message-ID: <e9c3a7c20804292342o38ca485by4dec2d137fefcac5@mail.gmail.com>
Date: Tue, 29 Apr 2008 23:42:46 -0700
From: "Dan Williams" <dan.j.williams@intel.com>
To: "Sebastian Siewior" <lkml@ml.breakpoint.cc>
Subject: Re: [PATCH] [ASYNC_TX] don't include <asm/> headers
Cc: "Maciej Sosnowski" <maciej.sosnowski@intel.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080426154801.GA18712@Chamillionaire.breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080426154801.GA18712@Chamillionaire.breakpoint.cc>
X-Google-Sender-Auth: f9988630d7d0fa14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 26, 2008 at 8:48 AM, Sebastian Siewior
<lkml@ml.breakpoint.cc> wrote:
> From: Sebastian Siewior <sebastian@breakpoint.cc>
>
>  Including arch dependent header files from arch indepent .c code
>  causes randconfig builds to fail. This patch fixes build problems on
>  arches which are not tested by Adrian like m68knommu.
>
>  Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>

Thanks, I'll push this out for testing in -next / -mm.

--
Dan
