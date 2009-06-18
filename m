Return-Path: <linux-kernel-owner+w=401wt.eu-S1756458AbZFRX4W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756458AbZFRX4W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 19:56:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752923AbZFRX4Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 19:56:16 -0400
Received: from mail-gx0-f214.google.com ([209.85.217.214]:46999 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753250AbZFRX4P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 19:56:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=gh1RyL1ZSJMQSOyV1efVCNKxGnWbor5FMDxQEc/TWa8JK0djOw18qy6E1y0Y77sD3B
         JOGb9Hx2o6cyi/Jo5Hx5WGlTiU5O2+MlFBwYF/xQoV+2/PZQxr1JEhhUKzcVBFOrGBIt
         2PIsFU4tbApNTlfBYSY5EsiP7JX+1EcljeWQ8=
MIME-Version: 1.0
In-Reply-To: <18995.20685.227683.561827@cargo.ozlabs.ibm.com>
References: <18995.20685.227683.561827@cargo.ozlabs.ibm.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Thu, 18 Jun 2009 19:55:58 -0400
Message-ID: <8bd0f97a0906181655jd68835fg10fe0783b6a6068d@mail.gmail.com>
Subject: Re: [PATCH 1/2] lib: Provide generic atomic64_t implementation
To: Paul Mackerras <paulus@samba.org>
Cc: benh@kernel.crashing.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 13, 2009 at 03:10, Paul Mackerras wrote:
> +typedef struct {
> +       long long counter;
> +} atomic64_t;

lack of volatile seems odd compared to:
include/linux/types.h:
typedef struct {
    volatile int counter;
} atomic_t;
-mike
