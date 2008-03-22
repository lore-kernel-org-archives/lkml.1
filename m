Return-Path: <linux-kernel-owner+w=401wt.eu-S1756413AbYCUT3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756413AbYCUT3U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 15:29:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751078AbYCUT3J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 15:29:09 -0400
Received: from wx-out-0506.google.com ([66.249.82.227]:31918 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845AbYCUT3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 15:29:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=date:to:cc:subject:message-id:organization:x-mailer:mime-version:content-type:content-transfer-encoding:from;
        b=au/pS2dNpffMGFyLiFIoPaLhqGXuuBx2PqevjYsofnyJSaIkX50E2LCAT3BrvphodpJh7uRq60H5CCgxHtCJZvlW5DTtlVkSsR9uyRRfEb+JA8GNNwobMl29wKLJft44rz58VbbAkMT+qDlWOiklKs0ESFnru3NIG0CkJz+Az+Y=
Date: Fri, 21 Mar 2008 20:30:40 -0700
To: rjw@sisk.pl
Cc: linux-main <linux-kernel@vger.kernel.org>
Subject: Proper way to invoke suspend?
Message-Id: <20080321203040.99655491.Kristoffer.Ericson@Gmail.com>
Organization: JLime
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.7; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
From: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael,

Been looking around for examples, but obviously something I don't understand. 
Currently I set apm_queue_event(APM_USER_SUSPEND) inside the power button interrupt, this does nothing.

However if I cat the state, it goes into suspend. Resume fails but thats another question.

Best Wishes
-- 
Kristoffer Ericson <Kristoffer.Ericson@Gmail.com>
