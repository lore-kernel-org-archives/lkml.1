Return-Path: <linux-kernel-owner+w=401wt.eu-S1756916AbZKJQ3v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756916AbZKJQ3v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 11:29:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756770AbZKJQ3t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 11:29:49 -0500
Received: from gv-out-0910.google.com ([216.239.58.185]:54902 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756137AbZKJQ3s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 11:29:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=ojd8DZ66Mbc1LVWE9Ty4icpkQh2JGp1sr0LKmJSMYB2ZmxnJEFee9OrCUJrQb/oF7P
         u/yeaPaBNKxTiQOSKbtK+GeCCYxxPkq9NCnHr/g8UVzO8BDY1WvDtK6RMR2Q/d2zTKlS
         y2S0YpqeN9xiXXtPmhM1L/BlnwPGP/Ksr7Ovs=
MIME-Version: 1.0
In-Reply-To: <1257869585-7092-8-git-send-email-john.johansen@canonical.com>
References: <1257869585-7092-1-git-send-email-john.johansen@canonical.com>
	 <1257869585-7092-8-git-send-email-john.johansen@canonical.com>
Date: Tue, 10 Nov 2009 18:29:52 +0200
X-Google-Sender-Auth: 41174ee98baf7e71
Message-ID: <84144f020911100829k515c7f73w84df942162a49a30@mail.gmail.com>
Subject: Re: [PATCH 07/12] AppArmor: userspace interfaces
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: John Johansen <john.johansen@canonical.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John,

On Tue, Nov 10, 2009 at 6:13 PM, John Johansen
<john.johansen@canonical.com> wrote:
> The current apparmorfs interface is compatible with previous versions
> of AppArmor.  The plans are to deprecate it (hence the config option
> APPARMOR_COMPAT_24) and replace it with a more sysfs style single
> entry per file interface.

We don't usually merge compatibility code to handle ABIs that were
developed out-of-tree. Why should we treat AppArmor differently?

                        Pekka
