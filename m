Return-Path: <linux-kernel-owner+w=401wt.eu-S1756283AbYHCHub@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756283AbYHCHub (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 03:50:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752650AbYHCHuY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 03:50:24 -0400
Received: from fk-out-0910.google.com ([209.85.128.185]:39365 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752623AbYHCHuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 03:50:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=V9/Ncsy5mbkhdSg9dBZoSPxs1h7HQ/lL2T22fLIvBQNnNuA6RWqY1vTsBbz1D0ngsM
         Lg0dQYt8yzYlvLjfnrUFndOJclcGgLzs6zFdzQaYDM5SBbLgPghiTNNfd50uboL8Sl3S
         +itPB3kVIQn2KtM71MQuDRZhvPaduM20vgTK0=
Message-ID: <d82e647a0808030050n3b72d96dh91c0ac94eadc34f@mail.gmail.com>
Date: Sun, 3 Aug 2008 15:50:19 +0800
From: "Ming Lei" <tom.leiming@gmail.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: [RFC] ftrace: support tracing functions in one module
Cc: linux-kernel@vger.kernel.org, "Ingo Molnar" <mingo@elte.hu>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Steven Rostedt" <srostedt@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

IMO, ftrace is a very good tools, which can monitor almost all
functions calling
in the running kernel. The traced result is very complete and intact.
But it seems
too large to grasp the interested content.  For example, one may only
have interest in
functions calling in usbcore.ko, but he must trace all the functions
calling in the
kernel, so the tracing result is too large to use it.

Could you add the support of tracing functions in one module only to ftrace?

Thanks,
