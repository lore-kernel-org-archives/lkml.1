Return-Path: <linux-kernel-owner+w=401wt.eu-S1752070AbZFOCmd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070AbZFOCmd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 22:42:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751341AbZFOCmJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 22:42:09 -0400
Received: from smtp-out.google.com ([216.239.45.13]:52036 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030AbZFOCmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 22:42:08 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:x-system-of-record;
	b=RqGRvWjpl4U7NSwRocDcOThESmw3WAZNu52nIfHVR5clswqKqstcff7vgwyc44i+U
	NwELChqf/YYCnaaOqcv2A==
From: Brian Swetland <swetland@google.com>
To: linux-arm-kernel@lists.arm.linux.org.uk
Cc: linux-kernel@vger.kernel.org, pavel@ucw.cz
Subject: Patches to get serial working on msm7k / htc dream
Date: Sun, 14 Jun 2009 19:39:14 -0700
Message-Id: <1245033557-10968-1-git-send-email-swetland@google.com>
X-Mailer: git-send-email 1.6.2.4
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This short patch series brings in the driver for the SoC's UART, 
some configuration glue to select a debug UART, updates for the 
debug uart macros, and a very minimal board file for HTC Dream.

With these patches you can actually see serial output from the
serial port on the extended USB connector, which makes debugging
further peripherals a lot easier.

(feedback on what I could do to make git-format-patch and git-send-email
generate better results, if these are displeasing, is most welcome)

Brian

