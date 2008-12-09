Return-Path: <linux-kernel-owner+w=401wt.eu-S1755229AbYLIWGp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755229AbYLIWGp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 17:06:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754268AbYLIWGg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 17:06:36 -0500
Received: from nf-out-0910.google.com ([64.233.182.188]:56573 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753543AbYLIWGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 17:06:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=bn25kqH3Fu0Inqs5Ct3GdsG4n0Uhy/m5Dq292ZXpdbX13JiuCj2Qty3/QzIKkif3ZC
         KTWb0JM1wf4JbZAJcNwwA9Xu2N2yylLH5v9dG1L+m/HIMxqa0oLowFu74H+fzY3lDLOP
         gKPbEXp0ZCyFWmKgzT+uihKQyr04yE6rY/SWM=
Message-ID: <493EEBD5.3020003@gmail.com>
Date: Tue, 09 Dec 2008 23:06:13 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Jeff Garzik <jgarzik@redhat.com>,
       Alexandru Romanescu <a_romanescu@yahoo.co.uk>,
       Tejun Heo <tj@kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 2/2 v2] ATA: piix, fix pointer deref on suspend
References: <493E0689.6020302@garzik.org> <1228855948-22886-1-git-send-email-jirislaby@gmail.com> <1228855948-22886-2-git-send-email-jirislaby@gmail.com> <493EE339.1070806@garzik.org>
In-Reply-To: <493EE339.1070806@garzik.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Note that the original version of this patch went upstream last night...

Ah, I'll repost it based on that fact then. Also I'll deinline dmi_match as
pointed out by Alan.
