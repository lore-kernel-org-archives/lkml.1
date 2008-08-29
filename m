Return-Path: <linux-kernel-owner+w=401wt.eu-S1754070AbYH2GRl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754070AbYH2GRl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 02:17:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752575AbYH2GPd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 02:15:33 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:59508 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408AbYH2GP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 02:15:27 -0400
Date: Thu, 28 Aug 2008 23:47:41 -0600
From: jmerkey@wolfmountaingroup.com
Message-Id: <200808290547.m7T5lf7E016121@wolfmountaingroup.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.27-rc5 6/29] mdb: add mdb-base.h architecure indepedent include
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

add mdb-base.h architecure indepedent include


Signed-off-by: Jeffrey Vernon Merkey (jmerkey@wolfmountaingroup.com)

--- a/debug/mdb/mdb-base.h	1969-12-31 17:00:00.000000000 -0700
+++ b/debug/mdb/mdb-base.h	2008-08-28 14:20:04.000000000 -0600
@@ -0,0 +1,296 @@
+
+/***************************************************************************
+*
+*   Copyright (c) 2008 Jeff V. Merkey  All Rights Reserved.
+*   1058 East 50 South
+*   Lindon, Utah 84042
+*   jmerkey@wolfmountaingroup.com
+*
+*   This program is free software; you can redistribute it and/or modify it
+*   under the terms of the GNU General Public License as published by the
+*   Free Software Foundation, version 2.
+*
+*   This program is distributed in the hope that it will be useful, but
+*   WITHOUT ANY WARRANTY; without even the implied warranty of
+*   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+*   General Public License for more details.
+*
+*   You are free to modify and re-distribute this program in accordance
+*   with the terms specified in the GNU Public License.  The copyright
+*   contained in this code is required to be present in any derivative
+*   works and you are required to provide the source code for this
+*   program as part of any commercial or non-commercial distribution.
+*   You are required to respect the rights of the Copyright holders
+*   named within this code.
+*
+*   jmerkey@wolfmountaingroup.com is the official maintainer of
+*   this code.  You are encouraged to report any bugs, problems, fixes,
+*   suggestions, and comments about this software.
+*
+*   AUTHOR   :  Jeff V. Merkey
+*   DESCRIP  :  Merkey's Linux Debugger
+*
+***************************************************************************/
+
+#ifndef _MDB_BASE_H
+#define _MDB_BASE_H
+
+extern unsigned long enterKeyACC(unsigned long key, void *stackFrame,
+		     ACCELERATOR *accel);
+extern unsigned long activateRegisterDisplayACC(unsigned long key, void *stackFrame,
+		     ACCELERATOR *accel);
+
+extern unsigned long displayDebuggerHelpHelp(unsigned char *commandLine, DEBUGGER_PARSER *parser);
+extern unsigned long displayDebuggerHelp(unsigned char *commandLine,
+			 StackFrame *stackFrame, unsigned long Exception,
+			 DEBUGGER_PARSER *parser);
+
+extern unsigned long ascTableHelp(unsigned char *commandLine, DEBUGGER_PARSER *parser);
+extern unsigned long displayASCTable(unsigned char *cmd,
+		     StackFrame *stackFrame, unsigned long Exception,
+		     DEBUGGER_PARSER *parser);
+
+extern unsigned long displayToggleHelp(unsigned char *commandLine, DEBUGGER_PARSER *parser);
+extern unsigned long ProcessTUToggle(unsigned char *cmd,
+		   StackFrame *stackFrame, unsigned long Exception,
+		   DEBUGGER_PARSER *parser);
+extern unsigned long ProcessTDToggle(unsigned char *cmd,
+		   StackFrame *stackFrame, unsigned long Exception,
+		   DEBUGGER_PARSER *parser);
+extern unsigned long ProcessTLToggle(unsigned char *cmd,
+		   StackFrame *stackFrame, unsigned long Exception,
+		   DEBUGGER_PARSER *parser);
+extern unsigned long ProcessTGToggle(unsigned char *cmd,
+		   StackFrame *stackFrame, unsigned long Exception,
+		   DEBUGGER_PARSER *parser);
+extern unsigned long ProcessTCToggle(unsigned char *cmd,
+		   StackFrame *stackFrame, unsigned long Exception,
+		   DEBUGGER_PARSER *parser);
+extern unsigned long ProcessTNToggle(unsigned char *cmd,
+		   StackFrame *stackFrame, unsigned long Exception,
+		   DEBUGGER_PARSER *parser);
+extern unsigned long ProcessTRToggle(unsigned char *cmd,
+		   StackFrame *stackFrame, unsigned long Exception,
+		   DEBUGGER_PARSER *parser);
+extern unsigned long ProcessTSToggle(unsigned char *cmd,
+		   StackFrame *stackFrame, unsigned long Exception,
+		   DEBUGGER_PARSER *parser);
+extern unsigned long ProcessTAToggle(unsigned char *cmd,
+		   StackFrame *stackFrame, unsigned long Exception,
+		   DEBUGGER_PARSER *parser);
+
+extern unsigned long displayDebuggerVersionHelp(unsigned char *commandLine, DEBUGGER_PARSER *parser);
+extern unsigned long DisplayDebuggerVersion(unsigned char *cmd,
+		   StackFrame *stackFrame, unsigned long Exception,
+		   DEBUGGER_PARSER *parser);
+
+extern unsigned long displayKernelProcessHelp(unsigned char *commandLine, DEBUGGER_PARSER *parser);
+extern unsigned long displayKernelProcess(unsigned char *cmd,
+			  StackFrame *stackFrame, unsigned long Exception,
+			  DEBUGGER_PARSER *parser);
+
+extern unsigned long displayKernelQueueHelp(unsigned char *commandLine, DEBUGGER_PARSER *parser);
+extern unsigned long displayKernelQueue(unsigned char *cmd,
+			StackFrame *stackFrame, unsigned long Exception,
+			DEBUGGER_PARSER *parser);
+
+extern unsigned long displaySymbolsHelp(unsigned char *commandLine, DEBUGGER_PARSER *parser);
+extern unsigned long displaySymbols(unsigned char *cmd,
+		    StackFrame *stackFrame, unsigned long Exception,
+		    DEBUGGER_PARSER *parser);
+
+extern unsigned long displayLoaderMapHelp(unsigned char *commandLine, DEBUGGER_PARSER *parser);
+extern unsigned long displayLoaderMap(unsigned char *cmd,
+		      StackFrame *stackFrame, unsigned long Exception,
+		      DEBUGGER_PARSER *parser);
+
+extern unsigned long displayModuleHelp(unsigned char *commandLine, DEBUGGER_PARSER *parser);
+extern unsigned long displayModuleInfo(unsigned char *cmd,
+		       StackFrame *stackFrame, unsigned long Exception,
+		       DEBUGGER_PARSER *parser);
+
+extern unsigned long displayProcessesHelp(unsigned char *commandLine, DEBUGGER_PARSER *parser);
+extern unsigned long displayProcesses(unsigned char *cmd,
+		      StackFrame *stackFrame, unsigned long Exception,
+		      DEBUGGER_PARSER *parser);
+
+extern unsigned long displayRegistersHelp(unsigned char *commandLine, DEBUGGER_PARSER *parser);
+extern unsigned long displayControlRegisters(unsigned char *cmd,
+			     StackFrame *stackFrame, unsigned long Exception,
+			     DEBUGGER_PARSER *parser);
+extern unsigned long displayAllRegisters(unsigned char *cmd,
+			     StackFrame *stackFrame, unsigned long Exception,
+			     DEBUGGER_PARSER *parser);
+extern unsigned long displaySegmentRegisters(unsigned char *cmd,
+			     StackFrame *stackFrame, unsigned long Exception,
+			     DEBUGGER_PARSER *parser);
+extern unsigned long displayNumericRegisters(unsigned char *cmd,
+			     StackFrame *stackFrame, unsigned long Exception,
+			     DEBUGGER_PARSER *parser);
+extern unsigned long displayGeneralRegisters(unsigned char *cmd,
+			     StackFrame *stackFrame, unsigned long Exception,
+			     DEBUGGER_PARSER *parser);
+extern unsigned long displayDefaultRegisters(unsigned char *cmd,
+			     StackFrame *stackFrame, unsigned long Exception,
+			     DEBUGGER_PARSER *parser);
+
+extern unsigned long displayAPICHelp(unsigned char *commandLine, DEBUGGER_PARSER *parser);
+extern unsigned long displayAPICInfo(unsigned char *cmd,
+		     StackFrame *stackFrame, unsigned long Exception,
+		     DEBUGGER_PARSER *parser);
+
+extern unsigned long listProcessors(unsigned char *cmd,
+		    StackFrame *stackFrame, unsigned long Exception,
+		    DEBUGGER_PARSER *parser);
+extern unsigned long listProcessorFrame(unsigned char *cmd,
+			StackFrame *stackFrame, unsigned long Exception,
+			DEBUGGER_PARSER *parser);
+
+extern unsigned long ReasonHelp(unsigned char *commandLine, DEBUGGER_PARSER *parser);
+extern unsigned long ReasonDisplay(unsigned char *cmd,
+	       StackFrame *stackFrame, unsigned long Exception,
+	       DEBUGGER_PARSER *parser);
+
+extern unsigned long displayMPSHelp(unsigned char *commandLine, DEBUGGER_PARSER *parser);
+extern unsigned long displayMPS(unsigned char *cmd,
+	       StackFrame *stackFrame, unsigned long Exception,
+	       DEBUGGER_PARSER *parser);
+
+extern unsigned long clearScreenHelp(unsigned char *commandLine, DEBUGGER_PARSER *parser);
+extern unsigned long clearDebuggerScreen(unsigned char *cmd,
+			 StackFrame *stackFrame, unsigned long Exception,
+			 DEBUGGER_PARSER *parser);
+
+
+extern unsigned long SearchMemoryHelp(unsigned char *commandLine, DEBUGGER_PARSER *parser);
+extern unsigned long SearchMemory(unsigned char *cmd,
+	       StackFrame *stackFrame, unsigned long Exception,
+	       DEBUGGER_PARSER *parser);
+extern unsigned long SearchMemoryB(unsigned char *cmd,
+	       StackFrame *stackFrame, unsigned long Exception,
+	       DEBUGGER_PARSER *parser);
+extern unsigned long SearchMemoryW(unsigned char *cmd,
+	       StackFrame *stackFrame, unsigned long Exception,
+	       DEBUGGER_PARSER *parser);
+extern unsigned long SearchMemoryD(unsigned char *cmd,
+	       StackFrame *stackFrame, unsigned long Exception,
+	       DEBUGGER_PARSER *parser);
+
+extern unsigned long changeMemoryHelp(unsigned char *commandLine, DEBUGGER_PARSER *parser);
+extern unsigned long changeWordValue(unsigned char *cmd,
+	       StackFrame *stackFrame, unsigned long Exception,
+	       DEBUGGER_PARSER *parser);
+extern unsigned long changeDoubleValue(unsigned char *cmd,
+	       StackFrame *stackFrame, unsigned long Exception,
+	       DEBUGGER_PARSER *parser);
+extern unsigned long changeByteValue(unsigned char *cmd,
+	       StackFrame *stackFrame, unsigned long Exception,
+	       DEBUGGER_PARSER *parser);
+extern unsigned long changeDefaultValue(unsigned char *cmd,
+			StackFrame *stackFrame, unsigned long Exception,
+			DEBUGGER_PARSER *parser);
+
+
+extern unsigned long displayCloseHelp(unsigned char *commandLine, DEBUGGER_PARSER *parser);
+extern unsigned long displayCloseSymbols(unsigned char *cmd,
+			 StackFrame *stackFrame, unsigned long Exception,
+			 DEBUGGER_PARSER *parser);
+
+
+extern unsigned long displayINTRHelp(unsigned char *commandLine, DEBUGGER_PARSER *parser);
+extern unsigned long displayInterruptTable(unsigned char *cmd,
+			   StackFrame *stackFrame, unsigned long Exception,
+			   DEBUGGER_PARSER *parser);
+
+
+extern unsigned long viewScreensHelp(unsigned char *commandLine, DEBUGGER_PARSER *parser);
+extern unsigned long displayScreenList(unsigned char *cmd,
+		       StackFrame *stackFrame, unsigned long Exception,
+		       DEBUGGER_PARSER *parser);
+
+
+extern unsigned long displayIOAPICHelp(unsigned char *commandLine, DEBUGGER_PARSER *parser);
+extern unsigned long displayIOAPICInfo(unsigned char *cmd,
+		       StackFrame *stackFrame, unsigned long Exception,
+		       DEBUGGER_PARSER *parser);
+
+
+
+extern unsigned long displayDumpHelp(unsigned char *commandLine, DEBUGGER_PARSER *parser);
+extern unsigned long debuggerWalkStack(unsigned char *cmd,
+		       StackFrame *stackFrame, unsigned long Exception,
+		       DEBUGGER_PARSER *parser);
+extern unsigned long debuggerDumpLinkedList(unsigned char *cmd,
+			    StackFrame *stackFrame, unsigned long Exception,
+			    DEBUGGER_PARSER *parser);
+extern unsigned long debuggerDumpWord(unsigned char *cmd,
+		      StackFrame *stackFrame, unsigned long Exception,
+		      DEBUGGER_PARSER *parser);
+extern unsigned long debuggerDumpStack(unsigned char *cmd,
+		       StackFrame *stackFrame, unsigned long Exception,
+		       DEBUGGER_PARSER *parser);
+extern unsigned long debuggerDumpDoubleStack(unsigned char *cmd,
+			     StackFrame *stackFrame, unsigned long Exception,
+			     DEBUGGER_PARSER *parser);
+extern unsigned long debuggerDumpDouble(unsigned char *cmd,
+			StackFrame *stackFrame, unsigned long Exception,
+			DEBUGGER_PARSER *parser);
+extern unsigned long debuggerDumpByte(unsigned char *cmd,
+		      StackFrame *stackFrame, unsigned long Exception,
+		      DEBUGGER_PARSER *parser);
+
+
+extern unsigned long displayDisassembleHelp(unsigned char *commandLine, DEBUGGER_PARSER *parser);
+extern unsigned long processDisassemble16(unsigned char *cmd,
+			  StackFrame *stackFrame, unsigned long Exception,
+			  DEBUGGER_PARSER *parser);
+extern unsigned long processDisassemble32(unsigned char *cmd,
+			  StackFrame *stackFrame, unsigned long Exception,
+			  DEBUGGER_PARSER *parser);
+
+extern unsigned long rebootSystemHelp(unsigned char *commandLine, DEBUGGER_PARSER *parser);
+extern unsigned long rebootSystem(unsigned char *cmd, StackFrame *stackFrame, unsigned long Exception,
+	                  DEBUGGER_PARSER *parser);
+
+extern unsigned long displaySectionsHelp(unsigned char *commandLine, DEBUGGER_PARSER *parser);
+extern unsigned long displaySections(unsigned char *cmd,
+		             StackFrame *stackFrame, unsigned long Exception,
+		             DEBUGGER_PARSER *parser);
+extern unsigned long displayKernelProcessHelp(unsigned char *commandLine,
+                                      DEBUGGER_PARSER *parser);
+extern unsigned long displayKernelProcess(unsigned char *cmd,
+		                  StackFrame *stackFrame, unsigned long Exception,
+		                  DEBUGGER_PARSER *parser);
+extern unsigned long displayProcessorStatusHelp(unsigned char *commandLine,
+                                        DEBUGGER_PARSER *parser);
+extern unsigned long displayProcessorStatus(unsigned char *cmd,
+		       StackFrame *stackFrame, unsigned long Exception,
+		       DEBUGGER_PARSER *parser);
+
+extern unsigned long backTraceHelp(unsigned char *commandLine, DEBUGGER_PARSER *parser);
+extern unsigned long backTraceAllPID(unsigned char *cmd, StackFrame *stackFrame,
+                             unsigned long Exception, DEBUGGER_PARSER *parser);
+extern unsigned long backTracePID(unsigned char *cmd, StackFrame *stackFrame,
+                             unsigned long Exception, DEBUGGER_PARSER *parser);
+extern unsigned long backTraceStack(unsigned char *cmd, StackFrame *stackFrame,
+                             unsigned long Exception, DEBUGGER_PARSER *parser);
+extern unsigned long timedBreakpointHelp(unsigned char *commandLine,
+                                  DEBUGGER_PARSER *parser);
+extern unsigned long timerBreakpoint(unsigned char *cmd,
+                                     StackFrame *stackFrame,
+                                     unsigned long Exception,
+                                     DEBUGGER_PARSER *parser);
+extern unsigned long timerBreakpointClear(unsigned char *cmd,
+                                          StackFrame *stackFrame,
+                                          unsigned long Exception,
+                                          DEBUGGER_PARSER *parser);
+
+#if defined(CONFIG_MODULES)
+extern unsigned long listModulesHelp(unsigned char *commandLine, DEBUGGER_PARSER *parser);
+extern unsigned long listModules(unsigned char *cmd, StackFrame *stackFrame, unsigned long Exception,
+	                 DEBUGGER_PARSER *parser);
+extern unsigned long unloadModule(unsigned char *cmd, StackFrame *stackFrame, unsigned long Exception,
+	                 DEBUGGER_PARSER *parser);
+#endif
+
+#endif
