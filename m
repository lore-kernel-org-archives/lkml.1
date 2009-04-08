Return-Path: <linux-kernel-owner+w=401wt.eu-S1758114AbZDHLWQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758114AbZDHLWQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 07:22:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755261AbZDHLV6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 07:21:58 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:45148 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753473AbZDHLV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 07:21:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=s+arpTJ2tYcpbW2q0dprLSlyb7M622mb6WsMoH72lIssAOL4iwyiymgHBzDr9TH3RC
         pdhM6s2XKq22iS3vNRWwlZ+YjwCuouRjwcNcwDd6drZHAMT2epLmfVKKeW8Rq9GTA+y+
         uzDhBzyDFB1jK7CqEJ6JN11G22lhbBR33sF1U=
Message-ID: <49DC88D5.3070806@gmail.com>
Date: Wed, 08 Apr 2009 13:21:57 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1b3pre) Gecko/20090223 SUSE/3.0b2-8.1 Thunderbird/3.0b2
MIME-Version: 1.0
To: Eric Biederman <ebiederm@aristanetworks.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: [mmotm] sysctl: unexported linux/lockdep.h
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

sysctl-lockdep-support-for-sysctl-reference-counting.patch adds
#include <linux/lockdep.h> into include/linux/sysctl.h

sysctl.h is exported, but lockdep.h is not. Please move the include
inside the __KERNEL__ section.
