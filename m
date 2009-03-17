Return-Path: <linux-kernel-owner+w=401wt.eu-S1756208AbZCQGXr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756208AbZCQGXr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 02:23:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762529AbZCQGX1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 02:23:27 -0400
Received: from an-out-0708.google.com ([209.85.132.246]:52357 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762698AbZCQGX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 02:23:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=qj5jqoK4xYOZyupkiz7+nrOd2JtWfmh1cixGEbLdJQcHneEAPgn+iF5mVczMGMdrZ3
         FQMM8yYrUk4vZV0XIgFkx/sTJeMtzT85o4fYxWuA9osmPU23XKx6+/H/tEPgiA1hL+kG
         zKHzjbFNDdCq6Acr1csNVhvpUQW0LUQBLkfcI=
Subject: [RFC][PATCH 0/4] tracing: event filtering
From: Tom Zanussi <tzanussi@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain
Date: Tue, 17 Mar 2009 01:23:22 -0500
Message-Id: <1237271002.8033.148.camel@charm-linux>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patchset is a first attempt at adding filtering to the
event-tracing infrastructure.

The filtering itself seems to work ok, as far as I've been able to test
it, but I'm still battling with getting the ring-buffer to do what I
want (discarding events, see patch 2) so am hoping someone more familiar
with the ring buffer can point me in the right direction before I do any
more work on it.

Another specific thing it would be good to get comments on would be how
to allow the user to unambiguously specify a field name in a filter when
there are duplicate field names for an event, as mentioned in patch 1.

Of course, any comments about the rest of the interface and code are
also welcome...

Thanks,

Tom
 

