Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753538Ab0CEH4i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 02:56:38 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:52281 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768Ab0CEH4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 02:56:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=i2w23peyAISOy4JBy7dwmy0sTlhgtepjEY1FSr8wcPLz04oMjLgMiJOaOze3wwKy8a
         ujeaBS9AkV4Iw9NvvueEEYQ9UPAJjy8bp0kHAgF85y8ayEn5LtsvLur9t16PFFBkA/eH
         rd1oXehsTolLPYS8BIS3f28rrAN4yXpcOMVXE=
MIME-Version: 1.0
Date: Fri, 5 Mar 2010 15:56:36 +0800
Message-ID: <c6ed1ac51003042356y5ccb42f1va550747b9e72129e@mail.gmail.com>
Subject: sched_fair: the schedule check condition?
From: figo zhang <figo1802@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

in check_preempt_tick() funtion, the check schedule condition the
reality increasing runtime "delta_exec"
and vruntime increasing "delta", and reality ideal time "ideal_runtime":

            if (delta_exec > ideal_runtime)
and
            if (delta > ideal_runtime)

if equal,  it should be need schedule?

Best,
Figo.zhang
