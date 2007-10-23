Return-Path: <linux-kernel-owner+w=401wt.eu-S1753473AbXJWAtb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473AbXJWAtb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 20:49:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751402AbXJWAtX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 20:49:23 -0400
Received: from smtp-out.google.com ([216.239.45.13]:24582 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029AbXJWAtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 20:49:23 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:user-agent:mime-version:to:cc:
	subject:content-type:content-transfer-encoding;
	b=WfyBeCD6IdAAFLpokHgHzsdQEQ0nQJbzXGafKnStIfyNyYsh+qVa6MFISMFME2GGh
	r2n5BvhYy05tWhuRw+mCQ==
Message-ID: <471D4506.5090200@google.com>
Date: Mon, 22 Oct 2007 17:49:10 -0700
From: Paul Menage <menage@google.com>
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>
CC: containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] CFS CGroup: cleanup & usage reporting
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

These two patches consist of a small cleanup to CFS, and adding a control file reporting CPU usage in milliseconds in each CGroup directory. They're just bundled together since the second patch depends slightly on the cleanups in the first patch.

