Return-Path: <linux-kernel-owner+w=401wt.eu-S1754041AbZELT1A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041AbZELT1A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 15:27:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751778AbZELT0u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 15:26:50 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:26020 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974AbZELT0t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 15:26:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=ODGS5uKu8VhUR1NTcy6uXuWWyGf49GGIJwnGq3THlfd6PLYV5ymEsjtbHotOLnHQlp
         7DFAcNocMJzSseKcbsFmPVzHkFJoGBOeWtVwOHuC5uZ7Q+6tGj5NuW/9q5KWbNYPYlXi
         NtN35DLq9m6Zsj6sjvkoXi/D0sRzldlHtcUN0=
MIME-Version: 1.0
In-Reply-To: <200905121301.08524.bjorn.helgaas@hp.com>
References: <20090507105821.GA5864@hash.localnet>
	 <1241747634.3773.129.camel@localhost.localdomain>
	 <200905121301.08524.bjorn.helgaas@hp.com>
Date: Tue, 12 May 2009 15:26:50 -0400
X-Google-Sender-Auth: 29f24bef0d0de043
Message-ID: <b6c5339f0905121226n5e1bd058v3220196728024e55@mail.gmail.com>
Subject: Re: acpi/suspend - irq 9: nobody cared
From: Bob Copeland <me@bobcopeland.com>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: yakui_zhao <yakui.zhao@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 12, 2009 at 3:01 PM, Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> Even if you can't bisect this, can you please open a bugzilla at
> http://bugzilla.kernel.org ?  Also, if you can verify that it is
> really a regression since 2.6.29, please drop a note to Rafael,
> who tracks regressions.  Plus, he knows all about suspend/resume,
> so maybe he can even fix it :)

Yeah, I'll open a bug report for it.  I'm in the process of bisecting
but there's a boot hang somewhere in the window (2.6.29 <-> .30-rc2)
so it's taking some time.

-- 
Bob Copeland %% www.bobcopeland.com
