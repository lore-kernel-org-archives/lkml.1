Return-Path: <linux-kernel-owner+w=401wt.eu-S1760349AbZJIKCu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760349AbZJIKCu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 06:02:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753554AbZJIKCt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 06:02:49 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:40355 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753076AbZJIKCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 06:02:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=MprYLLphNqenSE1+Gjx4QGpJdAlp6BSuJZS8nxFgpn+g6+3F0bZ4Mk6UIL5/Yq+3LZ
         2t9AD6tk9c5Q6VrV6ybfGB5Ab3PvSGiX3oOwfico/zky+GhGNoXqIyYbig5GF+plOr5x
         Xb9uvlrZe4KB8CNkJrfWQd/IfYHv0dBLiKIoA=
Message-ID: <4ACF09D7.9030901@gmail.com>
Date: Fri, 09 Oct 2009 12:00:55 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-2.7 Thunderbird/3.0b4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: mm-commits@vger.kernel.org, Avi Kivity <avi@redhat.com>,
       Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org
Subject: [was: mmotm 2009-10-09-01-07 uploaded]
References: <200910090830.n998Ubvv020464@imap1.linux-foundation.org>
In-Reply-To: <200910090830.n998Ubvv020464@imap1.linux-foundation.org>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/09/2009 10:07 AM, akpm@linux-foundation.org wrote:
> The mm-of-the-moment snapshot 2009-10-09-01-07 has been uploaded to

Hi, build fails with:
ERROR: "cpufreq_get" [arch/x86/kvm/kvm.ko] undefined!
because of
CONFIG_KVM=m
...
# CONFIG_CPU_FREQ is not set

Should cpufreq_get be defined as inline return 0 the same as
cpufreq_quick_get on !CONFIG_CPU_FREQ?
