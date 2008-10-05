Return-Path: <linux-kernel-owner+w=401wt.eu-S1755256AbYJELWh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256AbYJELWh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 07:22:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753557AbYJELW3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 07:22:29 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:59561 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752874AbYJELW3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 07:22:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=cAZauR+m5uuUGlZpOuHQ8QpzTGXm8YbxKBf+KRFci3EHqLZhb40gzhJZBlYJPeXal7
         bSR9oeyg7U3TzxjTj0ejRr82/V+iSIwbVPoYwoLX5U2MMRjod0BAmxoP6Ax/LqkHRtZx
         ubyGUEpMlAMGLLID7qjxFcEK3ZxjdBCIHGeiI=
Message-ID: <c62985530810050422m23d875b1s46ed19c8b65b96e4@mail.gmail.com>
Date: Sun, 5 Oct 2008 13:22:27 +0200
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH -tip] Fastboot: fix initcalls disposition in bootgraph.pl
Cc: "Arjan van de Ven" <arjan@infradead.org>, rostedt@goodmis.org,
       linux-kernel@vger.kernel.org, alan-jenkins@tuffmail.co.uk
In-Reply-To: <20081005095559.GE29909@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <48E7C594.4030400@gmail.com>
	 <20081004131901.66720416@infradead.org>
	 <c62985530810041328i282818cak8cd0ba36c450e3d6@mail.gmail.com>
	 <20081004133940.44feb2a0@infradead.org>
	 <20081005095559.GE29909@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/10/5 Ingo Molnar <mingo@elte.hu>:
> Frédéric, is the revert still needed, or is latest tip/master OK ?

Yes it should be reverted. Tracing is still stopped at the end of kernel_init().

Thanks!
