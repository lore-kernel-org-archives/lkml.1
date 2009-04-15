Return-Path: <linux-kernel-owner+w=401wt.eu-S1755445AbZDOFnf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755445AbZDOFnf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 01:43:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752205AbZDOFn0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 01:43:26 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:8126 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814AbZDOFnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 01:43:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=o78noh5TGqUDaE4sYqB3TZXrfFAmAkcCFPPZXiFwdmMzQ+yPSd2JU6JZR7YEohiENM
         1ITjuYFyqD+Jn/dy6yZw1+/HIAnBKjKIvHJfm+0WP7hipRuHvUTeL2luBFZVsGF8k3/x
         DtwNU6ifhEkt773RbiLv5L0qh6IHBJzwOIiLc=
MIME-Version: 1.0
In-Reply-To: <20090414211851.219d8b45@nehalam>
References: <20090414211851.219d8b45@nehalam>
Date: Tue, 14 Apr 2009 22:43:24 -0700
X-Google-Sender-Auth: 8525754c32066929
Message-ID: <e9c3a7c20904142243n3d4aa187i94b534cc43d85c9c@mail.gmail.com>
Subject: Re: Can't boot with "nosmp"
From: Dan Williams <dan.j.williams@intel.com>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 14, 2009 at 9:18 PM, Stephen Hemminger
<shemminger@vyatta.com> wrote:
> If I boot a KVM instance configured with 4 CPU's but pass the "nosmp" flag
> Host kernel is 2.6.30-rc1, guest kernel is 2.6.29.1
> It dies really early in boot, on a module I never use..
>

Hi Stephen,

I'll try to reproduce this.  In the meantime you can set
CONFIG_DMA_ENGINE=n as a workaround.  The output of
scripts/markup_oops.pl may help...

Thanks for the report,
Dan
