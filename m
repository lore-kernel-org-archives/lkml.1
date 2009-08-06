Return-Path: <linux-kernel-owner+w=401wt.eu-S1753896AbZHFLwo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753896AbZHFLwo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 07:52:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752614AbZHFLwn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 07:52:43 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:53272 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528AbZHFLwn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 07:52:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=gO2RlA7Z5p81Tv8YiVPpqXxAvs0QYvdnaVLcv7/LXp7wRnY4w3nvcGp8M2FJlBEZQy
         Vhmw3SgxzQtdNdyOT6RLF8Ou379oyZVlbP7k1x9j+8P1FH6jbWLHuhM8HQbbah+lliQF
         XV3YXj32UivKYXeOuxNgP61/pxFgPyKmfH1IM=
MIME-Version: 1.0
In-Reply-To: <20090805222920.GF19257@buzzloop.caiaq.de>
References: <1249496971-9019-1-git-send-email-daniel@caiaq.de>
	 <1249496971-9019-2-git-send-email-daniel@caiaq.de>
	 <200908052149.55567.elendil@planet.nl>
	 <20090805222920.GF19257@buzzloop.caiaq.de>
Date: Thu, 6 Aug 2009 13:52:41 +0200
Message-ID: <74d0deb30908060452k1fc0e982jf14be2e895e9a805@mail.gmail.com>
Subject: Re: [PATCH 2/5] pda-power: switch to new dev_pm_ops
From: pHilipp Zabel <philipp.zabel@gmail.com>
To: Daniel Mack <daniel@caiaq.de>
Cc: Frans Pop <elendil@planet.nl>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org, spyro@f2s.com, cbou@mail.ru,
       mreimer@vpop.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 6, 2009 at 12:29 AM, Daniel Mack<daniel@caiaq.de> wrote:
> On Wed, Aug 05, 2009 at 09:49:52PM +0200, Frans Pop wrote:
>> Daniel Mack wrote:
>> > +static struct dev_pm_ops pda_power_pm_ops = {
>> > +       .suspend        = pda_power_suspend,
>> > +       .freeze         = pda_power_freeze,
>>
>> Hmmm. Where's pda_power_freeze defined? Forgot to (compile)test the
>> patches?
>
> Yes, sorry. I can't test hibernation, so I didn't pay enough attention.
> I'll resend them anyway with Rafael's new macro used.

After Rafael's comments on gpio_keys, I believe also here
.freeze/.thaw should be empty. enable/disable_irq_wake should be
called from .poweroff/.restore.

regards
Philipp
