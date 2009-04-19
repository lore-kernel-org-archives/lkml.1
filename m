Return-Path: <linux-kernel-owner+w=401wt.eu-S1756273AbZDSJ0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756273AbZDSJ0T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 05:26:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753810AbZDSJ0I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 05:26:08 -0400
Received: from m50-135.163.com ([123.125.50.135]:37056 "HELO m50-135.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753450AbZDSJ0H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 05:26:07 -0400
From: "derekzheng" <zhengxiang9@163.com>
To: "'linuxppc-dev'" <linuxppc-dev@ozlabs.org>,
       <microblaze-uclinux@itee.uq.edu.au>, <linux-kernel@vger.kernel.org>
References: <764365e7af2e476e43cd674738e51f13b306979b.1239874968.git.monstr@monstr.eu>	<74c0088dfda1816c21914c0a8da0c42908526c5e.1239874968.git.monstr@monstr.eu>	<20090417170707.B6C95C4004F@mail150-wa4.bigfish.com> <fa686aa40904172249m5e261492w48c8d9d8446600e0@mail.gmail.com>
In-Reply-To: <fa686aa40904172249m5e261492w48c8d9d8446600e0@mail.gmail.com>
Subject: who know's what is "TestFloat cases" and how to test this feature on the Freescale MPC8536DS board
Date: Sun, 19 Apr 2009 17:25:26 +0800
Message-ID: <003001c9c0d0$c6919510$53b4bf30$@com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Acm/6Z7XMofHg6L2RD2WTrMRLYv+lAA1VE+w
Content-Language: zh-cn
x-cr-hashedpuzzle: Dkay FLyK FtfX I+rn NvE8 OwNt QTyu X6Mt ZaHC b6CI cS6N ctVA e61z f1ud g+MH g+lt;3;bABpAG4AdQB4AC0AawBlAHIAbgBlAGwAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA7AGwAaQBuAHUAeABwAHAAYwAtAGQAZQB2AEAAbwB6AGwAYQBiAHMALgBvAHIAZwA7AG0AaQBjAHIAbwBiAGwAYQB6AGUALQB1AGMAbABpAG4AdQB4AEAAaQB0AGUAZQAuAHUAcQAuAGUAZAB1AC4AYQB1AA==;Sosha1_v1;7;{DBE18CB0-064D-4F32-B5AA-69D01F1B0056};egBoAGUAbgBnAHgAaQBhAG4AZwA5AEAAMQA2ADMALgBjAG8AbQA=;Sun, 19 Apr 2009 09:25:17 GMT;dwBoAG8AIABrAG4AbwB3ACcAcwAgAHcAaABhAHQAIABpAHMAIAAiAFQAZQBzAHQARgBsAG8AYQB0ACAAYwBhAHMAZQBzACIAIABhAG4AZAAgAGgAbwB3ACAAdABvACAAdABlAHMAdAAgAHQAaABpAHMAIABmAGUAYQB0AHUAcgBlACAAbwBuACAAdABoAGUAIABGAHIAZQBlAHMAYwBhAGwAZQAgAE0AUABDADgANQAzADYARABTACAAYgBvAGEAcgBkAA==
x-cr-puzzleid: {DBE18CB0-064D-4F32-B5AA-69D01F1B0056}
X-CM-TRANSID: D9GowLD7RbUH7upJe7ElLw--.50483S2
X-Coremail-Antispam: 1Uf129KBjDUn29KB7ZKAUJUUUUUYxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUjMxYjxAI6xkYrwAYjxAI6xAIw28IcVW8ZrWlb7IF0VCF04k20xvE
	w2I207IF0wAYjxAI6xCIbckI1I0E57IF64kEYxAxM7k0a2IF6r1UM7kC6x804xWl14x267
	AKxVWUJVW8JwAFxVCF77xC6IxKo4kEV4yl1I0EscIYIxCEI4klw4CSwwAFIxvE14AKwVWU
	JVWUGwA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_GcCE3s1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
	GcCE3s1l57IF6s8CjcxG0xyl5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14
	v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwACjcxG0xvY0x0EwIxGrwAC62BYpTIE1TZK
	A3svLVAKvSnIqfZI6r4l7I0Y64k_MxkFs20EY4vE8sxKj4xv1wCY1Ik26cxK6x8YrwCY1I
	k26cxK6xAEc7vF620IrwCY02Avz4vE14v_GFWlc2IjII80xcxEwVAKI48JMxAIw28IcxkI
	7VAKI48JMxCjnVAqn7xvrwC2zVAF1VAY17CE14v26r1Y6r17YxBIdaVFxhVjvjDU0xZFpf
	9x07jIq2NUUUUU=
X-CM-SenderInfo: x2kh0wx0ld0wqz6rljoofrz/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all guys:

The Freescale MPC8536DS board Integrated TestFloat cases, and I do not know how to test this feature on this board.
Please tell me how to test it if you known

Thanks very much!

Derek



