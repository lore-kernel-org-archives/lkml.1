Return-Path: <linux-kernel-owner+w=401wt.eu-S1030279AbXCSQKc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030279AbXCSQKc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 12:10:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030309AbXCSQKb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 12:10:31 -0400
Received: from an-out-0708.google.com ([209.85.132.251]:22412 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030299AbXCSQKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 12:10:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=D/GlL9s8JAnI2qpfVSzswV3Sog5UURbVdDFI6nbSozBqHU7p+YRquwph3i+2P7PmHtkG/VEih/A/Uz+yX/ge6/DstWFeJ9nkbIUWr0BcI5mEFkrS+b5dedMLBlg+sKwqMuwo6+1uBtvyyx/K8VaXthY0hogXZbAhp4bGI4QnHnE=
Message-ID: <2625b9520703190910o20b5d0ccw57159240af9f07f9@mail.gmail.com>
Date: Mon, 19 Mar 2007 08:10:28 -0800
From: "Thushara Wijeratna" <thushw@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: how core dump (core size) works
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

I have a large process (~ 2G address space) and I want to get a core
if this crashes in production. I haven't been able to get the core
file size to a low enough value so that this doesn't end up eating a
lot of disk space on small partitions.
In general, if I decrease the ulimit -c param, I've noticed that a
core is not dumped at all.

I'm sorry if this is not appropriate for this alias, I've searched
around a lot of forums and couldn't find an answer.

Thanks,
thushara
