Return-Path: <linux-kernel-owner+w=401wt.eu-S1756939AbXGPIM5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756939AbXGPIM5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 04:12:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754061AbXGPIMt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 04:12:49 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:31189 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753844AbXGPIMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 04:12:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=Ho2ITXKQR1FdrBMTRtVVDq0GeKeF6hdnNgXhIXZcfTzkN5EZyxkUg27joYdlgaVZHeczbxr8bBsZ6o4jGyczTngK8t9hnBI6cRMI8yKz7MnrRi69ED2RhUJj3oAOcJlTjb9PsLgwfnUK5fydZNnZMvQyeMKZo/VECz6ntQu5CNs=
Message-ID: <a9e22dff0707160112pc3b7bfcmc73adbd4edec670e@mail.gmail.com>
Date: Mon, 16 Jul 2007 11:12:47 +0300
From: "Ni@m" <niam.niam@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, "Ingo Molnar" <mingo@elte.hu>
Subject: performance -cfs19 vs. -ck1 for 2.6.22
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I haven't made special tests to compare 2.6.22-cfs19 and 2.6.22-ck1,
but I see performance superiority of 2.6.22-ck1 using my own eyes.
Especially in mozilla-firefox ...
Using 2.6.22 or 2.6.22-cfs19 my firefox hangs for some time(~4-5
seconds) when I'm trying to open any url, but with 2.6.22-ck1 firefox
doesn't hang at all or at least for a second when I have lots of open
tabs.

What is the reason? Had Con made better scheduler than cfs and O(1) in
general kernel?

Kernel configuration in 2.6.22, 2.6.22-ck1, 2.6.22-cfs19 is similar.
