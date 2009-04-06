Return-Path: <linux-kernel-owner+w=401wt.eu-S1756211AbZDFODS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756211AbZDFODS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 10:03:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754751AbZDFODD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 10:03:03 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:56063 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754621AbZDFODB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 10:03:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=JhMWc2OGoIXNBLX6bCnJW7AMIs4NZIywVLZle4pnpRXo4wOcY1MOh/4KRdbLfDZQCF
         uqAFVuPAsl2/e41wVazzSwuzRvkVk2SFiVc85hHnSXazXqauedML0IrO/po0YkGL+MDo
         wybHcIlljVS9jaRFbcNR86M8pjNHa5EoQRimQ=
MIME-Version: 1.0
Date: Mon, 6 Apr 2009 23:02:59 +0900
Message-ID: <49b7c2350904060702j3f725a45ub5e7d3ee3af883c1@mail.gmail.com>
Subject: [PATCH] Update old Mini-HOWTO for ftrace
From: GeunSik Lim <leemgs1@gmail.com>
To: Steven Rostedt <srostedt@redhat.com>, Ingo Molnar <mingo@elte.hu>
Cc: rt-users <linux-rt-users@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=000e0cd311a21c6b1d0466e35b29
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--000e0cd311a21c6b1d0466e35b29
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

   Dear Steven,

   The author of ftrace(Internal kernel Function Tracer) feature
renamed the ftrace tracer
    to function to avoid further confusion between the ftrace
infrastructure and the
    function tracer on Oct-20, 2008.

    But, Update of Mini-HOWTO document are still not working
    .
    Most of the developers often utilize "/debug/tracing/README" file
as Mini-HOWTO.
    They will confuse definition and usage about ftrace  between
README(ftrace) file
    and available_tracers(function) file after linux-2.6.27 like me.
    And, I want you to append "chrt -f 5 sleep 1" command as simple
example for latency.

    Signed-off-by: GeunSik Lim <leemgs1@gmail.com>
    Signed-off-by: Steven Rostedt <srostedt@redhat.com>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/trace/trace.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index a0174a4..15f0eec 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2358,7 +2358,7 @@ static const char readme_msg[] =
        "# mkdir /debug\n"
        "# mount -t debugfs nodev /debug\n\n"
        "# cat /debug/tracing/available_tracers\n"
-       "wakeup preemptirqsoff preemptoff irqsoff ftrace sched_switch none\n\n"
+       "wakeup preemptirqsoff preemptoff irqsoff function
sched_switch none\n\n"
        "# cat /debug/tracing/current_tracer\n"
        "none\n"
        "# echo sched_switch > /debug/tracing/current_tracer\n"
@@ -2368,6 +2368,7 @@ static const char readme_msg[] =
        "noprint-parent nosym-offset nosym-addr noverbose\n"
        "# echo print-parent > /debug/tracing/trace_options\n"
        "# echo 1 > /debug/tracing/tracing_enabled\n"
+       "# chrt -f 5 sleep 1\n"
        "# cat /debug/tracing/trace > /tmp/trace.txt\n"
        "echo 0 > /debug/tracing/tracing_enabled\n"
 ;



-- 
Regards,
GeunSik Lim
--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/

--000e0cd311a21c6b1d0466e35b29
Content-Type: application/octet-stream; name="update-minihowto-ftrace.patch"
Content-Disposition: attachment; filename="update-minihowto-ftrace.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ft7rotyk0

QXV0aG9yOiBHZXVuU2lrICBMaW08bGVlbWdzMUBnbWFpbC5jb20+CkRhdGU6ICAgTW9uIEFwciA2
IDIyOjQ4OjE2IDIwMDkgKzA5MDAKCiAgICBbUEFUQ0hdIFVwZGF0ZSBNaW5pLUhPV1RPIGZvciBm
dHJhY2UKICAgIAogICAgVGhlIGF1dGhvciBvZiBmdHJhY2UoSW50ZXJuYWwga2VybmVsIEZ1bmN0
aW9uIFRyYWNlcikgZmVhdHVyZSByZW5hbWVkIHRoZSBmdHJhY2UgdHJhY2VyCiAgICB0byBmdW5j
dGlvbiB0byBhdm9pZCBmdXJ0aGVyIGNvbmZ1c2lvbiBiZXR3ZWVuIHRoZSBmdHJhY2UgaW5mcmFz
dHJ1Y3R1cmUgYW5kIHRoZQogICAgZnVuY3Rpb24gdHJhY2VyIG9uIE9jdC0yMCwgMjAwOC4KICAg
IAogICAgQnV0LCBVcGRhdGUgb2YgTWluaS1IT1dUTyBkb2N1bWVudCBhcmUgc3RpbGwgbm90IHdv
cmtpbmcKICAgIC4KICAgIE1vc3Qgb2YgdGhlIGRldmVsb3BlcnMgb2Z0ZW4gdXRpbGl6ZSAiL2Rl
YnVnL3RyYWNpbmcvUkVBRE1FIiBmaWxlIGFzIE1pbmktSE9XVE8uCiAgICBUaGV5IHdpbGwgY29u
ZnVzZSBkZWZpbml0aW9uIGFuZCB1c2FnZSBhYm91dCBmdHJhY2UgIGJldHdlZW4gUkVBRE1FKGZ0
cmFjZSkgZmlsZQogICAgYW5kIGF2YWlsYWJsZV90cmFjZXJzKGZ1bmN0aW9uKSBmaWxlIGFmdGVy
IGxpbnV4LTIuNi4yNyBsaWtlIG1lLgogICAgQW5kLCBJIHdhbnQgeW91IHRvIGFwcGVuZCAiY2hy
dCAtZiA1IHNsZWVwIDEiIGNvbW1hbmQgYXMgc2ltcGxlIGV4YW1wbGUgZm9yIGxhdGVuY3kuCiAg
ICAKICAgIFNpZ25lZC1vZmYtYnk6IEdldW5TaWsgTGltIDxsZWVtZ3MxQGdtYWlsLmNvbT4KICAg
IFNpZ25lZC1vZmYtYnk6IFN0ZXZlbiBSb3N0ZWR0IDxzcm9zdGVkdEByZWRoYXQuY29tPgogICAg
U2lnbmVkLW9mZi1ieTogSW5nbyBNb2xuYXIgPG1pbmdvQGVsdGUuaHU+Ci0tLQoga2VybmVsL3Ry
YWNlL3RyYWNlLmMgfCAgICAzICsrLQogMSBmaWxlcyBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKyks
IDEgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEva2VybmVsL3RyYWNlL3RyYWNlLmMgYi9rZXJu
ZWwvdHJhY2UvdHJhY2UuYwppbmRleCBhMDE3NGE0Li4xNWYwZWVjIDEwMDY0NAotLS0gYS9rZXJu
ZWwvdHJhY2UvdHJhY2UuYworKysgYi9rZXJuZWwvdHJhY2UvdHJhY2UuYwpAQCAtMjM1OCw3ICsy
MzU4LDcgQEAgc3RhdGljIGNvbnN0IGNoYXIgcmVhZG1lX21zZ1tdID0KICAgICAgICAiIyBta2Rp
ciAvZGVidWdcbiIKICAgICAgICAiIyBtb3VudCAtdCBkZWJ1Z2ZzIG5vZGV2IC9kZWJ1Z1xuXG4i
CiAgICAgICAgIiMgY2F0IC9kZWJ1Zy90cmFjaW5nL2F2YWlsYWJsZV90cmFjZXJzXG4iCi0gICAg
ICAgIndha2V1cCBwcmVlbXB0aXJxc29mZiBwcmVlbXB0b2ZmIGlycXNvZmYgZnRyYWNlIHNjaGVk
X3N3aXRjaCBub25lXG5cbiIKKyAgICAgICAid2FrZXVwIHByZWVtcHRpcnFzb2ZmIHByZWVtcHRv
ZmYgaXJxc29mZiBmdW5jdGlvbiBzY2hlZF9zd2l0Y2ggbm9uZVxuXG4iCiAgICAgICAgIiMgY2F0
IC9kZWJ1Zy90cmFjaW5nL2N1cnJlbnRfdHJhY2VyXG4iCiAgICAgICAgIm5vbmVcbiIKICAgICAg
ICAiIyBlY2hvIHNjaGVkX3N3aXRjaCA+IC9kZWJ1Zy90cmFjaW5nL2N1cnJlbnRfdHJhY2VyXG4i
CkBAIC0yMzY4LDYgKzIzNjgsNyBAQCBzdGF0aWMgY29uc3QgY2hhciByZWFkbWVfbXNnW10gPQog
ICAgICAgICJub3ByaW50LXBhcmVudCBub3N5bS1vZmZzZXQgbm9zeW0tYWRkciBub3ZlcmJvc2Vc
biIKICAgICAgICAiIyBlY2hvIHByaW50LXBhcmVudCA+IC9kZWJ1Zy90cmFjaW5nL3RyYWNlX29w
dGlvbnNcbiIKICAgICAgICAiIyBlY2hvIDEgPiAvZGVidWcvdHJhY2luZy90cmFjaW5nX2VuYWJs
ZWRcbiIKKyAgICAgICAiIyBjaHJ0IC1mIDUgc2xlZXAgMVxuIgogICAgICAgICIjIGNhdCAvZGVi
dWcvdHJhY2luZy90cmFjZSA+IC90bXAvdHJhY2UudHh0XG4iCiAgICAgICAgImVjaG8gMCA+IC9k
ZWJ1Zy90cmFjaW5nL3RyYWNpbmdfZW5hYmxlZFxuIgogOwoKCg==
--000e0cd311a21c6b1d0466e35b29--
